require "paygate/version"

require 'paygate/aes'
require 'paygate/aes_ctr'

require 'paygate/member'
require 'paygate/response'
require 'paygate/transaction'
require 'paygate/profile'

require 'paygate/helpers/form_helper' if defined? ActionView

module Paygate
  class Engine < ::Rails::Engine; end

  CONFIG = YAML.load(File.read(File.expand_path('../data/config.yml', File.dirname(__FILE__)))).freeze
  KOREA_BIN_NUMBERS = CONFIG[:korea][:bin_numbers].freeze
end
