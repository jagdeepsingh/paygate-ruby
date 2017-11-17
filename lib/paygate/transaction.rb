require 'digest'
require 'uri'
require 'net/http'

module Paygate
  class Transaction
    CANCEL_API_URL = 'https://service.paygate.net/service/cancelAPI.json'.freeze

    attr_reader :tid
    attr_accessor :member

    def initialize(tid)
      @tid = tid
    end

    def cancel(options = {})
      # Encrypt data
      api_key_256 = ::Digest::SHA256.hexdigest(member.secret)
      aes_ctr = AesCtr.encrypt(tid, api_key_256, 256)
      tid_enc = "AES256#{aes_ctr}"

      # Prepare params
      params = { callback: 'callback', mid: member.mid, tid: tid_enc }
      params.merge!(options.slice(:amount))
      params.delete_if { |_, v| v.blank? }

      # Make request
      uri = URI(CANCEL_API_URL)
      uri.query = ::URI.encode_www_form(params)
      response = ::Net::HTTP.get_response(uri)

      Response.build_from_net_http_response(:cancel, response)
    end
  end
end
