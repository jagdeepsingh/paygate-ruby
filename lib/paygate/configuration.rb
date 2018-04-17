module Paygate
  class Configuration
    MODES = %i(live sandbox).freeze

    attr_reader :mode

    def initialize
      @mode = :live
    end

    def mode=(value)
      fail 'Invalid mode. Value must be one of the following: :live, :sandbox' unless value && MODES.include?(value.to_sym)
      @mode = value.to_sym
    end
  end
end
