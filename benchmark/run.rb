"#{File.expand_path('..',File.dirname(__FILE__))}/lib".tap {|lib_dir| 
  $LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)
}

list1_length = ENV.fetch('L1', 100)
list2_length = ENV.fetch('L2', 200)
chunk_size   = ENV.fetch('CS', 10)
puts "Using list lengths #{list1_length} and #{list2_length} and chunk size #{chunk_size}"
puts "Set ENV vars L1, L2, and CS to change"

require 'mendel'
require 'time'
require 'benchmark'
require 'csv'

list1    = list1_length.times.map  { rand(1_000_000)        }.sort
list2    = list2_length.times.map  { rand(1_000_000) / 10.0 }.sort
combiner = Mendel::Combiner.new(list1, list2)
 
column_names = %i[cstime cutime real stime total utime]

puts "Benchmarking..."
stats = []
$stdout = File.open(File::NULL, 'w')
Benchmark.bm do |benchmark|
  done = false
  until done do
    # Ensure GC doesn't run during benchmarking
    GC.disable
    bm = benchmark.report do
      chunk = combiner.take(chunk_size)
      done = true if chunk.empty?
    end
    data_point = {queue_length: combiner.queue_length}
    column_names.map {|colname| data_point[colname] = bm.send(colname) }
    stats << data_point
    GC.enable
  end
end
$stdout = STDOUT

puts "Writing performance data into 'benchmark/data'"
Dir.chdir('benchmark') do
  Dir.mkdir('data') unless Dir.exist?('data')
  Dir.chdir('data') do
    filename = "#{list1.length}x#{list2.length}-#{chunk_size}_each"
    CSV.open("#{filename}.csv", "wb") do |csv|
      csv << stats.first.keys
      stats.each do |entry|
        csv << entry.values
      end
    end
  end
end
puts "Done!"
