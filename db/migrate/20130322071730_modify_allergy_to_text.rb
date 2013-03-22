class ModifyAllergyToText < ActiveRecord::Migration
  def up
    change_column :participants, :allergies, :text
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
