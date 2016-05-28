class Stop < ApplicationRecord
  validates :longitude, :latitude, presence: true

  scope :active, -> { where(active: true) }
end
