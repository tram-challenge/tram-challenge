class CreateAttemptStops < ActiveRecord::Migration[5.0]
  def change
    create_table :attempt_stops, id: :uuid do |t|
      t.references :attempt, foreign_key: true, type: :uuid
      t.references :stop, foreign_key: true, type: :uuid
      t.time :visited_at

      t.timestamps
    end
  end
end
