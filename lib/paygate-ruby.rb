require 'yaml'
require 'paygate/version'
require 'paygate/configuration'
require 'paygate/aes'
require 'paygate/aes_ctr'
require 'paygate/member'
require 'paygate/response'
require 'paygate/transaction'
require 'paygate/profile'
require 'paygate/helpers/form_helper' if defined?(ActionView)

module Paygate
  if defined?(Rails)
    class Engine < ::Rails::Engine; end
  end

  CONFIG = YAML.load(File.read(File.expand_path('../data/config.yml', File.dirname(__FILE__)))).freeze
  LOCALES_MAP = CONFIG[:locales].freeze
  INTL_BRANDS_MAP = CONFIG[:intl][:brands].freeze
  KOREA_BIN_NUMBERS = CONFIG[:korea][:bin_numbers].freeze

  DEFAULT_CURRENCY = 'WON'.freeze
  DEFAULT_LOCALE = 'US'.freeze

  def mapped_currency(currency)
    return DEFAULT_CURRENCY unless currency.present?

    currency.to_s == 'KRW' ? 'WON' : currency.to_s
  end
  module_function :mapped_currency

  def mapped_locale(locale)
    locale.present? ? LOCALES_MAP[locale.to_s] : DEFAULT_LOCALE
  end
  module_function :mapped_locale

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
end
