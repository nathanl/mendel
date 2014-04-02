require "bundler/gem_tasks"
require 'mendel'
require_relative "benchmark/basic_combiner"
Bundler.setup

desc "Open IRB to experiment with Mendel::Combiner"
task :console do
  require 'irb'
  require 'irb/completion'
  require 'colorize'
  require_relative 'lib/mendel'
  ARGV.clear
  IRB.start
end
