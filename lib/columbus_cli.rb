require 'thor'
require 'pry'
require 'columbus_cli/converter'
require 'columbus_cli/strava_uploader'

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

    desc 'upload FILE', 'Uploads a gpx file to a fitness tracking service (default: Strava, see options for more)'
    option :to, default: 'strava', enum: %w(strava)
    def upload(file)
      uploader = ColumbusCli::StravaUploader.new
      activity_type = ask 'What kind of activity is this?', limited_to: %w(ride run swim workout hike walk nordicski alpineski backcountryski iceskate inlineskate kitesurf rollerski windsurf workout snowboard snowshoe ebikeride virtualride)
      res = uploader.upload(file, activity_type)
      if res == false
        say('This data type is not allowed!', RED)
      else
        say('Done! Visit your account with a browser to check on your new activity')
      end
    end
  end
end
