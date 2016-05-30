class AddLongitudeAndLatitudeToAttemptStops < ActiveRecord::Migration[5.0]
  def change
    add_column :attempt_stops, :longitude, :decimal, precision: 18, scale: 15
    add_column :attempt_stops, :latitude, :decimal, precision: 18, scale: 15
  end
end
