module Paygate
  class Response
    attr_accessor :transaction_type, :http_code, :message, :body, :json

    def self.build_from_net_http_response(txn_type, response)
      r = new
      r.transaction_type = txn_type
      r.http_code = response.code
      r.message = response.message
      r.body = response.body

      case txn_type
        when :cancel
          r.json = JSON.parse response.body.gsub(/^callback\((.*)\)$/, '\1') if response.code.to_i == 200
        when :profile_pay
          r.json = {}
          response.body.split('&').each do |key_value_pair|
            key_value_ary = key_value_pair.split('=')
            r.json[key_value_ary[0]] = key_value_ary[1]
          end
      end
      r
    end
  end
end
