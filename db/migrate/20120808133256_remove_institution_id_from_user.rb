class RemoveInstitutionIdFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :institution_id
  end

  def down
  end
end
