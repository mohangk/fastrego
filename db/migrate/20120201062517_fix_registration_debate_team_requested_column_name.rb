class FixRegistrationDebateTeamRequestedColumnName < ActiveRecord::Migration
  def change
    rename_column :registrations, :debate_team_requested, :debate_teams_requested
  end
end
