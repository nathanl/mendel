require_relative 'benchmarker'
require_relative 'addition_combiner'

chunk_size   = ENV.fetch('CS', 25)
puts "Using chunk size #{chunk_size} - set ENV var CS to change"

lists = 6.times.map {
  # More than this eats a ton of memory
  8.times.map { rand(1.0...1_000.0) }.sort
}

# require 'pry'
# binding.pry
# exit

benchmarker = Mendel::Benchmarker.new(AdditionCombiner.new(*lists), chunk_size)
benchmarker.go!
