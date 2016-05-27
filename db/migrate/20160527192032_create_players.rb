class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players, id: :uuid do |t|
      t.string :icloud_user_id
      t.string :nickname

      t.timestamps
    end
    add_index :players, :icloud_user_id, unique: true
  end
end
