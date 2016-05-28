class Attempt < ApplicationRecord
  belongs_to :player

  validates :player, presence: true

  scope :in_progress, -> { where(finished_at: nil) }
end
