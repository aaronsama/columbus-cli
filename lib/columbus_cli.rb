require 'thor'

class ColumbusCli < Thor

  desc 'csv2gpx CSV_FILE', 'Convert a CSV file created by a Columbus Tracklogger to GPX'
  option :output, desc: 'Output file', required: true
  def csv2gpx(csv_file)
    puts "Converting #{csv_file} to #{options[:output]}..."

    track = Track.new File.expand_path(csv_file)
    gpx = GPX::GPXFile.new tracks: [track.to_gpx]
    gpx.write(File.expand_path(options[:output]))

    puts "Conversion complete"
  end

end

require 'columbus_cli/track.rb'
