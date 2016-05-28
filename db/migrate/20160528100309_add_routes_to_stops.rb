class AddRoutesToStops < ActiveRecord::Migration[5.0]
  def change
    add_column :stops, :routes, :string, array: true, default: []
    add_index :stops, :routes, using: :gin
  end
end
