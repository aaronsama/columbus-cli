require 'thor'
require 'pry'
require 'columbus_cli/converter'

module ColumbusCli
  class CLI < Thor
    desc 'csv2gpx CSV_FILE', 'Convert a CSV file created by a Columbus Tracklogger to GPX. Use wildcards to convert multiple files at once.'
    option :output, aliases: '-o', desc: 'Output file or directory (for multiple files only)', required: false
    def csv2gpx(*csv_files)
      res = csv_files.map do |f|
        output_file ||= f.gsub(/.csv\z/i, '.gpx')
        output_file += File.basename(f).gsub(/.csv\z/i, '.gpx') if File.directory?(output_file)
        if file_collision(output_file)
          ColumbusCli::Converter.new(f).convert_to(output_file)
        else
          false
        end
      end
      say "Converted #{res.count(true)} out of #{res.count} files!", GREEN
    end
  end
end
