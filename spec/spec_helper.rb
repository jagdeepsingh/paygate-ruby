# frozen_string_literal: true

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'paygate-ruby'

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = 'random'
end
