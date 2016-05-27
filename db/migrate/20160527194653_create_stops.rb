class CreateStops < ActiveRecord::Migration[5.0]
  def change
    create_table :stops, id: :uuid do |t|
      t.decimal :longitude, precision: 18, scale: 15
      t.decimal :latitude, precision: 18, scale: 15
      t.string :name
      t.string :stop_numbers, array: true, default: []
      t.string :hsl_ids, array: true, default: []

      t.timestamps
    end

    add_index :stops, [:longitude, :latitude]
    add_index :stops, :stop_numbers, using: :gin
    add_index :stops, :hsl_ids, using: :gin
  end
end
