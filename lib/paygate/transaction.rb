require 'digest'
require 'uri'
require 'net/http'

module Paygate
  class Transaction
    FULL_AMOUNT_IDENTIFIER = 'F'.freeze

    attr_reader :tid
    attr_accessor :member

    def initialize(tid)
      @tid = tid
    end

    def refund(options = {})
      # Encrypt data
      api_key_256 = ::Digest::SHA256.hexdigest(member.secret)
      aes_ctr = AesCtr.encrypt(tid, api_key_256, 256)
      tid_enc = "AES256#{aes_ctr}"

      # Prepare params
      params = { callback: 'callback', mid: member.mid, tid: tid_enc }
      params.merge!(options.slice(:amount))
      params[:amount] ||= FULL_AMOUNT_IDENTIFIER
      params[:mb_serial_no] = options[:order_id]
      params.delete_if { |_, v| v.blank? }

      # Make request
      uri = URI(self.class.refund_api_url)
      uri.query = ::URI.encode_www_form(params)
      response = ::Net::HTTP.get_response(uri)

      r = Response.build_from_net_http_response(:refund, response)
      r.raw_info = OpenStruct.new(tid: tid, tid_enc: tid_enc, request_url: uri.to_s)
      r
    end

    # Doc: https://km.paygate.net/pages/viewpage.action?pageId=9207875
    def verify
      params = { tid: tid, verifyNum: 100 }

      uri = URI('https://service.paygate.net/djemals/settle/verifyReceived.jsp')
      uri.query = ::URI.encode_www_form(params)
      response = ::Net::HTTP.get_response(uri)

      Response.build_from_net_http_response(:verify, response)
    end

    private

    def self.refund_api_url
      (Paygate.configuration.mode == :live) ?
        'https://service.paygate.net/service/cancelAPI.json' :
        'https://stgsvc.paygate.net/service/cancelAPI.json'
    end
  end
end
