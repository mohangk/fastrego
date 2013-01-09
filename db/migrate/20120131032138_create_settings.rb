class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key, unique: true
      t.string :value
      t.integer :tournament_id

      t.timestamps
    end
  end
end
