require 'gpx'

module ColumbusCli
  class Track
    def initialize(file)
      @points = []
      CSV.foreach(file, headers: true) do |p|
        tag = p["TAG"]

        date = "20#{p['DATE'].scan(/../).join('-')}"
        time = "#{p['TIME'].length == 6 ? p['TIME'] : '0' + p['TIME']}".scan(/../).join(':')

        ts = Time.parse "#{date}T#{time} GMT"
        lat = parse_lat p["LATITUDE N/S"]
        lon = parse_lon p["LONGITUDE E/W"]
        speed = p["SPEED"].to_i
        alt = p["HEIGHT"].to_i
        @points << {
          time:      ts,
          lat:       lat,
          lon:       lon,
          speed:     speed,
          elevation: alt,
          waypoint:  (tag == 'C')
        }
      end
    end

    def to_gpx
      segment = GPX::Segment.new
      @points.each do |p|
        point = GPX::TrackPoint.new(p)
        segment.append_point point
      end

      track = GPX::Track.new
      track.append_segment segment

      track
    end

    private

    def parse_lat str
      str[-1] == 'N' ? str.to_f : -str.to_f
    end

    def parse_lon str
      str[-1] == 'E' ? str.to_f : -str.to_f
    end

  end
end
