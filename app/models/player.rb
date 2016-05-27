class Player < ApplicationRecord
  validates :icloud_user_id, presence: true, uniqueness: true
end
