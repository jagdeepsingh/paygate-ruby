# frozen_string_literal: true

require 'uri'
require 'net/http'

module Paygate
  class Profile
    PURCHASE_URL = 'https://service.paygate.net/INTL/pgtlProcess3.jsp'

    attr_reader :profile_no
    attr_accessor :member

    def initialize(profile_no)
      @profile_no = profile_no
    end

    def purchase(currency, amount)
      # Prepare params
      params = { profile_no: profile_no,
                 mid: member.mid,
                 goodcurrency: currency,
                 unitprice: amount }
      params.compact!

      # Make request
      uri = URI(PURCHASE_URL)
      uri.query = ::URI.encode_www_form(params)
      response = ::Net::HTTP.get_response(uri)

      Response.build_from_net_http_response(:profile_pay, response)
    end
  end
end
