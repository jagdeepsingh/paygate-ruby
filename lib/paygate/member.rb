# frozen_string_literal: true

module Paygate
  class Member
    attr_reader :mid, :secret

    def initialize(mid, secret)
      @mid = mid
      @secret = secret
    end

    def refund_transaction(txn_id, options = {})
      txn = Transaction.new(txn_id)
      txn.member = self
      txn.refund(options)
    end

    def profile_pay(profile_no, currency, amount)
      profile = Profile.new(profile_no)
      profile.member = self
      profile.purchase(currency, amount)
    end
  end
end
