require "bundler/gem_tasks"

desc "Open IRB to experiment with Mendel::Combiner"
task :console do
  require 'irb'
  require 'irb/completion'
  require_relative 'lib/mendel'
  ARGV.clear
  IRB.start
end
