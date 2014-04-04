require_relative 'benchmarker'
require_relative 'addition_combiner'

list1_length = ENV.fetch('L1', 100)
list2_length = ENV.fetch('L2', 200)
chunk_size   = ENV.fetch('CS', 10)
puts "Using list lengths #{list1_length} and #{list2_length} and chunk size #{chunk_size}"
puts "Set ENV vars L1, L2, and CS to change"

list1    = list1_length.times.map  { rand(1_000_000)       }.sort
list2    = list2_length.times.map  { rand(1.0...1_000_000) }.sort

benchmarker = Mendel::Benchmarker.new(AdditionCombiner.new(list1, list2), chunk_size)
benchmarker.go!
