class CreateTournamentTable < ActiveRecord::Migration

  def change 
    create_table :tournaments do |t|
      t.string :name
      t.boolean :active, default: true
      t.string :identifier
      t.references :admin_user
      t.timestamps
    end
  end

end
