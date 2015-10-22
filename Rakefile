require "bundler/gem_tasks"
require 'mendel'
require_relative "benchmark/addition_combiner"
require 'rspec/core/rake_task'
Bundler.setup

RSpec::Core::RakeTask.new(:spec)

task "default" => "spec"

desc "Open IRB to experiment with Mendel::Combiner"
task :console do
  require 'irb'
  require 'irb/completion'
  require_relative 'lib/mendel'
  ARGV.clear
  IRB.start
end

desc "See a visualization of the Mendel::Combiner algorithm"
task :visualize do
  require 'irb'
  require "mendel/observable_combiner"
  require "mendel/visualizers/ascii"
  class ConsoleCombiner < Mendel::ObservableCombiner
    def score_combination(items)
      items.reduce(0) { |sum, item| sum += item }
    end
  end

  def clear_screen
    system('clear') or system('cls')
  end

  def show(limit = nil)
    list1 = 10.times.map { rand(100) }.sort
    list2 = 10.times.map { rand(1.0...100.0) }.sort
    combiner = ConsoleCombiner.new(list1, list2)
    visualizer = Mendel::Visualizers::ASCII.new(combiner)
    combiner.each_with_index do |combo, i|
      break if limit.kind_of?(Numeric) && i > limit
      clear_screen
      puts visualizer.output
      sleep(0.5)
    end; nil
  end
  ARGV.clear
  clear_screen
  puts "Mendel works like rising water, finding the lowest points"
  puts "Type 'show()'. Optionally, pass a max number of frames"
  IRB.start
end
