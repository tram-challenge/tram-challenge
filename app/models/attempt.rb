class Attempt < ApplicationRecord
  belongs_to :player
  has_many :attempt_stops, dependent: :destroy
  has_many :stops, through: :attempt_stops

  validates :player, presence: true

  scope :in_progress, -> { where(finished_at: nil) }

  before_create :initialize_attempt_stops

  def elapsed_time
    if finished_at
      finished_at.to_i - started_at.to_i
    else
      Time.current.to_i - started_at.to_i
    end
  end

  private def initialize_attempt_stops
    Stop.active.each do |stop|
      self.attempt_stops.build(stop: stop)
    end
  end
end
