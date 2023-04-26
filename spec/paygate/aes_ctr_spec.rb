# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Paygate::AesCtr do
  let(:plaintext) { 'This is a test message' }
  let(:password) { 'password' }
  let(:num_bits) { 128 }
  let(:encrypted_text) { "yACaHyMKGQCJtHL8KR0loRQOGV5zIjbGHltR8QL4\n" }
  let(:invalid_num_bits) { 2560 }

  describe '.encrypt' do
    before do
      allow(Object).to receive(:rand).and_return(0.123456789)
    end

    around do |example|
      Timecop.freeze(Time.utc(2022, 1, 1)) { example.run }
    end

    it 'returns an encrypted text string' do
      expect(described_class.encrypt(plaintext, password, num_bits)).to eq(encrypted_text)
    end

    it 'returns an empty string if num_bits is invalid' do
      expect(described_class.encrypt(plaintext, password, invalid_num_bits)).to eq('')
    end
  end

  describe '.decrypt' do
    it 'returns a decrypted text string' do
      decrypted_text = described_class.decrypt(encrypted_text, password, num_bits)
      expect(decrypted_text).to eq(plaintext)
    end

    it 'returns an empty string if num_bits is invalid' do
      expect(described_class.decrypt(encrypted_text, password, invalid_num_bits)).to eq('')
    end
  end
end
