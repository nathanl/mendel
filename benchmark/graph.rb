data_dir = File.expand_path('data', File.dirname(__FILE__))
unless Dir.exist?(data_dir)
  puts "No data directory found: #{data_dir}"
  exit 
end

require 'gruff'
require 'csv'

Dir.glob("#{data_dir}/*.csv") do |data_file|
  queue_lengths = []
  utimes        = []

  CSV.foreach(data_file, headers: true) do |row|
    utimes        << row.fetch('utime').to_f
    queue_lengths << row.fetch('queue_length').to_i
  end 

  g = Gruff::Line.new
  g.data(:utimes, utimes)
  g.title = "Time per .take()"
  g.write("#{data_file}_utimes.png")

  g = Gruff::Line.new
  g.data(:queue_length, queue_lengths)
  g.title = "Queue Length per .take()"
  g.write("#{data_file}_queue_lengths.png")



end
