class AddTournamentFkeys < ActiveRecord::Migration
  def change
   add_column :settings, :tournament_id, :integer 
   add_column :registrations, :tournament_id, :integer 
  end
end
