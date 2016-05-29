class Player < ApplicationRecord
  has_many :attempts, dependent: :destroy
  has_many :attempt_stops, through: :attempts

  validates :icloud_user_id, presence: true, uniqueness: true

  def nickname
    self[:nickname].present? ? self[:nickname] : "Anonymous"
  end
end
