class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name
      t.string :abbreviation
      t.string :website
      t.string :country
      t.string :type
      t.integer :tournament_id
      t.timestamps
    end
  end
end
