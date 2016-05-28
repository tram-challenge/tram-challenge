class Attempt < ApplicationRecord
  belongs_to :player
  has_many :attempt_stops, dependent: :destroy
  has_many :stops, through: :attempt_stops

  validates :player, presence: true

  scope :in_progress, -> { where(finished_at: nil) }
end
