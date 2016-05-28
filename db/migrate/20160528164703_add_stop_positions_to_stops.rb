class AddStopPositionsToStops < ActiveRecord::Migration[5.0]
  def change
    add_column :stops, :stop_positions, :jsonb, default: {}
  end
end
