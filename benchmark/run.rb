"#{File.expand_path('..',File.dirname(__FILE__))}/lib".tap {|lib_dir| 
  $LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)
}
require 'mendel'
require 'time'
require 'benchmark'
require 'csv'

list1    = 1_000.times.map  { rand(1_000_000)        }.sort
list2    = 1_000.times.map  { rand(1_000_000) / 10.0 }.sort
combiner = Mendel::Combiner.new(list1, list2)
 
chunk_size = 1_000
column_names = %i[cstime cutime real stime total utime]

stats = []
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

puts "Writing performance data into 'benchmark/data'..."
Dir.chdir('benchmark') do
  Dir.mkdir('data') unless Dir.exist?('data')
  Dir.chdir('data') do
    filename = Time.now.strftime("%Y-%m-%d_%H-%M-%S-#{list1.length}x#{list2.length}-#{chunk_size}_each")
    CSV.open("#{filename}.csv", "wb") do |csv|
      csv << stats.first.keys
      stats.each do |entry|
        csv << entry.values
      end
    end
  end
end
