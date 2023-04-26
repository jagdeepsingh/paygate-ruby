# frozen_string_literal: true

require 'base64'

module Paygate
  class AesCtr
    #  Encrypt a text using AES encryption in Counter mode of operation
    #
    #  Unicode multi-byte character safe
    #
    #  @param string plaintext Source text to be encrypted
    #  @param string password  The password to use to generate a key
    #  @param int num_bits     Number of bits to be used in the key (128, 192, or 256)
    #  @returns string         Encrypted text
    def self.encrypt(plaintext, password, num_bits)
      block_size = 16 # block size fixed at 16 bytes / 128 bits (Nb=4) for AES
      return '' unless [128, 192, 256].include?(num_bits)

      # use AES itself to encrypt password to get cipher key (using plain password as source for key
      # expansion) - gives us well encrypted key (though hashed key might be preferred for prod'n use)
      num_bytes = num_bits / 8 # no bytes in key (16/24/32)
      pw_bytes = []
      # use 1st 16/24/32 chars of password for key #warn
      0.upto(num_bytes - 1) do |i|
        pw_bytes[i] = (password.bytes.to_a[i] & 0xff) || 0
      end
      key = Aes.cipher(pw_bytes, Aes.key_expansion(pw_bytes)) # gives us 16-byte key
      key += key[0, num_bytes - 16] # expand key to 16/24/32 bytes long

      # initialise 1st 8 bytes of counter block with nonce (NIST SP800-38A §B.2): [0-1] = millisec,
      # [2-3] = random, [4-7] = seconds, together giving full sub-millisec uniqueness up to Feb 2106
      counter_block = []
      nonce = Time.now.to_i
      nonce_ms = nonce % 1000
      nonce_sec = (nonce / 1000.0).floor
      nonce_rand = (rand * 0xffff).floor
      0.upto(1) { |i| counter_block[i] = urs(nonce_ms, i * 8) & 0xff }
      0.upto(1) { |i| counter_block[i + 2] = urs(nonce_rand, i * 8) & 0xff }
      0.upto(3) { |i| counter_block[i + 4] = urs(nonce_sec, i * 8) & 0xff }

      # and convert it to a string to go on the front of the ciphertext
      ctr_text = ''
      0.upto(7) { |i| ctr_text += counter_block[i].chr }

      # generate key schedule - an expansion of the key into distinct Key Rounds for each round
      key_schedule = Aes.key_expansion(key)
      block_count = (plaintext.length / block_size.to_f).ceil

      cipher_text = []
      0.upto(block_count - 1) do |b|
        # set counter (block #) in last 8 bytes of counter block (leaving nonce in 1st 8 bytes)
        # done in two stages for 32-bit ops: using two words allows us to go past 2^32 blocks (68GB)
        0.upto(3) { |c| counter_block[15 - c] = urs(b, c * 8) & 0xff }
        0.upto(3) { |c| counter_block[15 - c - 4] = urs(b / 0x100000000, c * 8) }

        cipher_cntr = Aes.cipher(counter_block, key_schedule) # -- encrypt counter block --
        # block size is reduced on final block
        block_length = b < block_count - 1 ? block_size : ((plaintext.length - 1) % block_size) + 1
        cipher_char = []
        0.upto(block_length - 1) do |i|
          cipher_char[i] = (cipher_cntr[i] ^ plaintext.bytes.to_a[(b * block_size) + i]).chr
        end
        cipher_text[b] = cipher_char.join
      end

      cipher_text = ctr_text + cipher_text.join
      "#{Base64.encode64(cipher_text).delete("\n")}\n" # encode in base64
    end

    # Decrypt a text encrypted by AES in counter mode of operation
    #
    # @param string ciphertext Source text to be encrypted
    # @param string password   The password to use to generate a key
    # @param int n_bits      Number of bits to be used in the key (128, 192, or 256)
    # @returns string
    #           Decrypted text
    def self.decrypt(ciphertext, password, n_bits)
      block_size = 16 # block size fixed at 16 bytes / 128 bits (Nb=4) for AES
      return '' unless [128, 192, 256].include?(n_bits)

      ciphertext = Base64.decode64(ciphertext)

      n_bytes = n_bits / 8 # no bytes in key (16/24/32)
      pw_bytes = []
      0.upto(n_bytes - 1) { |i| pw_bytes[i] = (password.bytes.to_a[i] & 0xff) || 0 }
      key = Aes.cipher(pw_bytes, Aes.key_expansion(pw_bytes)) # gives us 16-byte key
      key.concat(key.slice(0, n_bytes - 16)) # expand key to 16/24/32 bytes long
      # recover nonce from 1st 8 bytes of ciphertext
      counter_block = []
      ctr_txt = ciphertext[0, 8]
      0.upto(7) { |i| counter_block[i] = ctr_txt.bytes.to_a[i] }

      # generate key Schedule
      key_schedule = Aes.key_expansion(key)

      # separate ciphertext into blocks (skipping past initial 8 bytes)
      n_blocks = ((ciphertext.length - 8) / block_size.to_f).ceil
      ct = []
      0.upto(n_blocks - 1) { |b| ct[b] = ciphertext[8 + (b * block_size), 16] }

      ciphertext = ct; # ciphertext is now array of block-length strings

      # plaintext will get generated block-by-block into array of block-length strings
      plaintxt = []
      0.upto(n_blocks - 1) do |b|
        0.upto(3) { |c| counter_block[15 - c] = urs(b, c * 8) & 0xff }
        0.upto(3) { |c| counter_block[15 - c - 4] = urs((b + 1) / (0x100000000 - 1), c * 8) & 0xff }
        cipher_cntr = Aes.cipher(counter_block, key_schedule) # encrypt counter block
        plaintxt_byte = []
        0.upto(ciphertext[b].length - 1) do |i|
          # -- xor plaintxt with ciphered counter byte-by-byte --
          plaintxt_byte[i] = (cipher_cntr[i] ^ ciphertext[b].bytes.to_a[i]).chr
        end
        plaintxt[b] = plaintxt_byte.join
      end
      plaintxt.join
    end

    # Unsigned right shift function, since Ruby has neither >>> operator nor unsigned ints
    #
    # @param a  number to be shifted (32-bit integer)
    # @param b  number of bits to shift a to the right (0..31)
    # @return   a right-shifted and zero-filled by b bits
    def self.urs(a, b)
      a &= 0xffffffff
      b &= 0x1f
      if (a & 0x80000000) && b.positive? # if left-most bit set
        a = ((a >> 1) & 0x7fffffff) # right-shift one bit & clear left-most bit
        a = a >> (b - 1)            # remaining right-shifts
      else # otherwise
        a = (a >> b);            # use normal right-shift
      end
      a
    end
  end
end
