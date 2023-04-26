module Paygate
  class Configuration
    MODES = %i[live sandbox].freeze

    attr_reader :mode

    def initialize
      @mode = :live
    end

    def mode=(value)
      value = value.to_sym
      fail 'Invalid mode. Value must be one of the following: :live, :sandbox' unless value && MODES.include?(value)
      @mode = value
    end
  end
end
