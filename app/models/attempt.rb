class Attempt < ApplicationRecord
  belongs_to :player
  has_many :attempt_stops, -> { order(visited_at: :asc) }, dependent: :destroy
  has_many :stops, through: :attempt_stops

  validates :player, presence: true

  scope :in_progress, -> { where(finished_at: nil) }
  scope :completed, -> { where.not(finished_at: nil) }

  scope :fully_completed, -> {
    joins("LEFT JOIN attempt_stops
      ON (attempts.id = attempt_stops.attempt_id AND attempt_stops.visited_at IS NULL)
    ").group("attempts.id").having("count(attempt_stops.id) = 0")
  }
  scope :order_by_elapsed, -> {
    order("(COALESCE(attempts.finished_at, current_timestamp) - attempts.started_at) ASC")
  }

  before_create :initialize_attempt_stops

  def self.fully_completed_and_valid
    # for now min 3 hours - do more validation later
    fully_completed.order_by_elapsed.select {|attempt| attempt.elapsed_time > 60 * 60 * 3}
  end

  def elapsed_time(pretty: false)
    seconds = if finished_at
      finished_at.to_i - started_at.to_i
    else
      Time.current.to_i - started_at.to_i
    end

    if pretty
      mm, ss = seconds.divmod(60)
      hh, mm = mm.divmod(60)
      dd, hh = hh.divmod(24)

      if dd > 0
        "%02d:%02d:%02d:%02d" % [dd, hh, mm, ss]
      else
        "%02d:%02d:%02d" % [hh, mm, ss]
      end
    else
      seconds
    end
  end

  def to_gpx
    gpx = GPX::GPXFile.new

    track = GPX::Track.new(name: "Tram Challenge attempt by #{player.nickname}")
    segment = GPX::Segment.new

    attempt_stops.each do |as|
      data = {
        lat: as.stop.latitude, lon: as.stop.longitude, time: as.visited_at
      }

      segment.points << GPX::TrackPoint.new(data)
      gpx.waypoints << GPX::Waypoint.new(data.merge({ name: as.stop.name }))
    end

    track.segments << segment
    gpx.tracks << track

    gpx.to_s
  end

  private def initialize_attempt_stops
    Stop.active.each do |stop|
      self.attempt_stops.build(stop: stop)
    end
  end
end
