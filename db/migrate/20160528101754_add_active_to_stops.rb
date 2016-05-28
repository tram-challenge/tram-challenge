class AddActiveToStops < ActiveRecord::Migration[5.0]
  def change
    add_column :stops, :active, :boolean, default: true
    add_index :stops, :active
  end
end
