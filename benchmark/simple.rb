"#{File.expand_path('..',File.dirname(__FILE__))}/lib".tap {|lib_dir| 
  $LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)
}

require 'mendel'
require 'time'
require_relative 'addition_combiner'

list_count   = ENV.fetch('LIST_COUNT', 10).to_i
list_length  = ENV.fetch('LIST_LENGTH', 200).to_i
result_count = ENV.fetch('RESULT_COUNT', 10_000).to_i

puts "Pulling #{result_count} results from #{list_count} lists of #{list_length} each"
puts "You may override with ENV vars LIST_COUNT, LIST_LENGTH, RESULT_COUNT"

if result_count >= list_length**list_count
  puts "***(You asked for #{result_count} results, but only #{list_length**list_count} are possible...)"
end

lists = list_count.times.map {
  list_length.times.map { rand(1.0...1_000.0) }.sort
}

puts "Look at the starting memory usage - you have 10 seconds"
sleep(10)
puts "about to do the work"
start = Time.now
GC.disable
bc = AdditionCombiner.new(*lists)
bc.take(result_count)
fin = Time.now
puts "Took #{fin - start} seconds to pull #{result_count} combos"
puts "Look at the final memory usage - you have 10 seconds till exit"
sleep(10)
