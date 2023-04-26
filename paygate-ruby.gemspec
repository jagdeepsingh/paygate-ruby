# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'paygate/version'

Gem::Specification.new do |spec|
  spec.name          = 'paygate-ruby'
  spec.version       = Paygate::VERSION
  spec.authors       = ['jagdeepsingh']
  spec.email         = ['jagdeepsingh.125k@gmail.com']
  spec.summary       = 'Ruby wrapper for PayGate Korea payment gateway'
  spec.license       = 'MIT'

  spec.files         = Dir.glob('{data,lib,vendor}/**/*') + %w[CHANGELOG.md LICENSE.txt README.md Rakefile]
  spec.test_files    = Dir.glob('spec/**/*')
  spec.require_paths = ['lib']
end
