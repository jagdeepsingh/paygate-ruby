module Paygate
  class Member
    attr_reader :mid, :secret

    def initialize(mid, secret)
      @mid, @secret = mid, secret
    end

    def cancel_transaction(txn_id, options = {})
      txn = Transaction.new(txn_id)
      txn.member = self
      txn.cancel(options)
    end
  end
end
