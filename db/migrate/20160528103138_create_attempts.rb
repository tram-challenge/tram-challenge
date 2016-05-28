class CreateAttempts < ActiveRecord::Migration[5.0]
  def change
    create_table :attempts, id: :uuid do |t|
      t.references :player, foreign_key: true, type: :uuid
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
