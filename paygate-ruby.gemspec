# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'paygate/version'

Gem::Specification.new do |spec|
  spec.name          = 'paygate-ruby'
  spec.version       = Paygate::VERSION
  spec.authors       = ['jagdeepsingh']
  spec.email         = ['jagdeepsingh.125k@gmail.com']
  spec.summary       = 'Ruby wrapper for PayGate Korea payment gateway'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.6.0'
  spec.files         = Dir.glob('{data,lib,vendor}/**/*') + %w[CHANGELOG.md LICENSE.txt README.md Rakefile]
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
end
