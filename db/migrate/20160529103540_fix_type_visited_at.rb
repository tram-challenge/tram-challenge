class FixTypeVisitedAt < ActiveRecord::Migration[5.0]
  def change
    remove_column :attempt_stops, :visited_at
    add_column :attempt_stops, :visited_at, :datetime, index: true
  end
end
