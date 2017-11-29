# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "paygate/version"

Gem::Specification.new do |spec|
  spec.name          = "paygate-ruby"
  spec.version       = Paygate::VERSION
  spec.authors       = ["jagdeepsingh"]
  spec.email         = ["jagdeepsingh.125k@gmail.com"]

  spec.summary       = 'Ruby wrapper for PayGate payment gateway'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
end
