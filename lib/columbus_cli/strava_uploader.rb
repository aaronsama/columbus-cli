require 'strava/api/v3'

module ColumbusCli
  class StravaUploader

    ALLOWED_TYPES = %w(.fit .fit.gz .tcx .tcx.gz .gpx .gpx.gz).freeze

    def initialize
      load_access_token
      @client = Strava::Api::V3::Client.new(access_token: @access_token)
      puts "Hello #{@client.retrieve_current_athlete['firstname']}"
    end

    def upload(file, activity_type)
      return false unless ALLOWED_TYPES.include?(File.extname(file))

      # Prepare options for upload
      options = {}
      options[:activity_type] = activity_type
      options[:data_type] = File.extname(file)[1..-1]

      # Open the file from the file systems
      options[:file] = File.new(file)

      # Submit upload and get upload ID
      status = @client.upload_an_activity(options)
      upload_id = status['id']

      # Re-poll for status
      @client.retrieve_upload_status(upload_id)
    end

    private

    def load_access_token
      if File.exist?(File.expand_path('~/.columbuscli'))
        authorization_file = YAML::load_file(File.expand_path('~/.columbuscli'))
        unless authorization_file['access_token']
          access_information = Strava::Api::V3::Auth.retrieve_access(authorization_file['client_id'], authorization_file['client_secret'], authorization_file['authorization_code'])
          # binding.pry
          authorization_file['access_token'] = access_information['access_token']
          authorization_file.delete('authorization_code')
          File.open(File.expand_path('~/.columbuscli'), 'w') { |f| f.write authorization_file.to_yaml }
        end
        @access_token = authorization_file['access_token']
      else
        puts <<-eos
          NO CONFIGURATION FILE FOUND!
          Please follow these simple steps:
          1. Go to your strava account and create a new application (set localhost as callback domain)
          2. Visit https://www.strava.com/settings/api
          3. Find and visit the link to your OAuth Authorization page, adding '&scope=write'
          4. Copy the authorization_code from the URL params into ~/.columbuscli as follows
              authorization_code: YOUR_AUTHORIZATION_CODE
          5. Add the following information to the file
              client_id: YOUR_CLIENT_ID
              client_secret: YOUR_CLIENT_SECRET
        eos
        abort
      end
    end
  end
end
