class Stop < ApplicationRecord
  validates :longitude, :latitude, presence: true
end
