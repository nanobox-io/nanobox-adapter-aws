# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ec2/version'

Gem::Specification.new do |spec|
  spec.name          = "ec2"
  spec.version       = EC2::VERSION
  spec.authors       = ["Tyler Flint"]
  spec.email         = ["tyler@nanobox.io"]
  spec.summary       = %q{ec2 is a standard library for exposing ec2 resources to nanobox.}
  spec.description   = %q{A standard library for exposing ec2 resources to nanobox.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'right_aws_api'
  spec.add_dependency 'faraday'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
