class Player < ApplicationRecord
  has_many :attempts, dependent: :destroy

  validates :icloud_user_id, presence: true, uniqueness: true
end
