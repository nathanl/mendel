"#{File.expand_path('..',File.dirname(__FILE__))}/lib".tap {|lib_dir| 
  $LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)
}

require 'mendel'
require 'time'
require 'benchmark'
require 'csv'

class Mendel::Benchmarker
  attr_accessor :combiner, :chunk_size
  def initialize(combiner, chunk_size)
    self.combiner   = combiner
    self.chunk_size = chunk_size
  end

  # Look! A big ol' procedural script shoved into a method!
  def go!
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
        lengths  = combiner.lists.map {|l| l.length.to_s}.join('x')
        filename = "#{lengths}-#{chunk_size}_each"
        CSV.open("#{filename}.csv", "wb") do |csv|
          csv << stats.first.keys
          stats.each do |entry|
            csv << entry.values
          end
        end
      end
    end
    puts "Done!"

  end
end
