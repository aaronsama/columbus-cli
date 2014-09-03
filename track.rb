require 'gpx'

class Track

  def initialize(file)
    @points = []
    CSV.foreach(file, headers: true) do |p|
      tag = p["TAG"]
      ts = Time.parse "20#{p['DATE'].scan(/../).join('-')}T#{p['TIME'].scan(/../).join(':')}"
      lat = parse_lat p["LATITUDE N/S"]
      lon = parse_lon p["LONGITUDE E/W"]
      speed = p["SPEED"].to_i
      alt = p["HEIGHT"].to_i
      @points << { time: ts, lat: lat, lon: lon, speed: speed, elevation: alt, waypoint: (tag == 'C') }
    end
  end

  def to_gpx
    segment = GPX::Segment.new
    @points.each do |p|
      if p[:waypoint]
        segment.append_point GPX::Waypoint.new(p)
      else
        segment.append_point GPX::TrackPoint.new(p)
      end
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