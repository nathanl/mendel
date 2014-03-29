# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mendel/version'

Gem::Specification.new do |spec|
  spec.name          = "mendel"
  spec.version       = Mendel::VERSION
  spec.authors       = ["Nathan Long"]
  spec.email         = ["nathanmlong@gmail.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "PriorityQueue",      "~> 0.1.2"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   "~> 3.0.0.beta2"
  spec.add_development_dependency "pry",     "~> 0.9"
  spec.add_development_dependency "gruff",   "~> 0.5"
end
