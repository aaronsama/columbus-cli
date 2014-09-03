#!/usr/bin/env ruby
require 'optparse'
require 'gpx'
require './track'

optparser = OptionParser.new do |opts|
  opts.banner = "Usage: csv2gpx.rb file1 [file2 ...]"
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
end

optparser.parse!

ARGV.each do |f|
  if ['.csv','.CSV'].include? File.extname(f)
    outputfile = f.downcase.sub('.csv', '.gpx')
    puts "Converting #{f} to #{outputfile}..."
    track = Track.new f

    gpx = GPX::GPXFile.new tracks: [track.to_gpx]
    gpx.write(outputfile)

    gpx = nil

    puts "Conversion complete"
  else
    puts "#{f} is not a CSV file!"
  end
end