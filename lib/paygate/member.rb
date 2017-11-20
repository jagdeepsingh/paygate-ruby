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

    def profile_pay(profile_no, currency, amount)
      profile = Profile.new(profile_no)
      profile.member = self
      profile.purchase(currency, amount)
    end
  end
end
