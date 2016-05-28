class Attempt < ApplicationRecord
  belongs_to :player

  validates :player, presence: true
end
