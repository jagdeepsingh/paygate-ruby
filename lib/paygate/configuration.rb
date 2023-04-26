# frozen_string_literal: true

module Paygate
  class Configuration
    MODES = %i[live sandbox].freeze

    attr_reader :mode

    def initialize
      @mode = :live
    end

    def mode=(value)
      value = value.to_sym
      raise 'Invalid mode. Value must be one of the following: :live, :sandbox' unless value && MODES.include?(value)

      @mode = value
    end
  end
end
