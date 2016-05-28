class AttemptStop < ApplicationRecord
  belongs_to :attempt
  belongs_to :stop

  scope :visited, -> { where.not(visited_at: nil) }
end
