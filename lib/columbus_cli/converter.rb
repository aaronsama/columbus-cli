require 'columbus_cli/track'
require 'thor'

module ColumbusCli
  class Converter
    def initialize(input_file)
      @input_file = input_file
    end

    def convert_to(output_file)
      track = Track.new File.expand_path(@input_file)
      gpx = GPX::GPXFile.new tracks: [track.to_gpx]
      gpx.write(File.expand_path(output_file))
    end
  end
end
