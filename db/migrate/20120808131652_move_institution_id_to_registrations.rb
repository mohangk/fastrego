class MoveInstitutionIdToRegistrations < ActiveRecord::Migration
  def up
    rename_column :registrations, :user_id, :team_manager_id
    add_column :registrations, :institution_id, :integer
  end

  def down
  end
end
