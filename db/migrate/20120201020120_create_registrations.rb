class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :debate_teams_requested
      t.integer :adjudicators_requested
      t.integer :observers_requested
      t.integer :debate_teams_granted
      t.integer :adjudicators_granted
      t.integer :observers_granted
      t.integer :debate_teams_confirmed
      t.integer :observers_confirmed
      t.integer :adjudicators_confirmed
      t.integer :team_manager_id
      t.integer :institution_id
      t.integer :tournament_id
      t.decimal :fees, precision: 14, scale: 2
      t.timestamp :requested_at

      t.timestamps
    end
  end
end
