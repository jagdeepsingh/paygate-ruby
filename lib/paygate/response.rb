module Paygate
  class Response
    attr_accessor :transaction_type, :http_code, :message, :body, :json

    def self.build_from_net_http_response(txn_type, response)
      r = new
      r.transaction_type = txn_type
      r.http_code = response.code
      r.message = response.message
      r.body = response.body
      r.json = JSON.parse response.body.gsub(/^callback\((.*)\)$/, '\1') if response.code.to_i == 200
      r
    end
  end
end
