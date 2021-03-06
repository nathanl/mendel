# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mendel/version'

Gem::Specification.new do |spec|
  spec.name          = "mendel"
  spec.version       = Mendel::VERSION
  spec.authors       = ["Nathan Long"]
  spec.email         = ["nathanmlong@gmail.com"]
  spec.summary       = %q{Mendel breeds the best combinations of lists that you provide.}
  spec.description   = %q{Mendel breeds the best combinations of N lists without building all possible combinations.}
  spec.homepage      = "https://github.com/nathanl/mendel"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "PriorityQueue",      "~> 0.1.2"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec",   "~> 3.4"
  spec.add_development_dependency "pry",     "~> 0.10"
  spec.add_development_dependency "colorize", "~> 0.7.7"
end
