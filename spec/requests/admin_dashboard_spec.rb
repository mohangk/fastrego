require 'spec_helper'

def columns(row_text)
  row_text.split("\n").map { |s| s.strip }.reject { |s| s.empty? }
end

describe 'AdminLogin' do
  let!(:t2) { FactoryGirl.create(:t2_tournament) }
  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com') }
  let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com') }
  let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager, debate_teams_requested: 1, adjudicators_requested: 2, observers_requested: 3, debate_teams_granted: 1, adjudicators_granted: 1, observers_granted: 1 ,debate_teams_confirmed: 1, adjudicators_confirmed: 0, observers_confirmed: 0 ) }
  let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager, debate_teams_requested: 10, adjudicators_requested: 20, observers_requested: 30, debate_teams_granted: 10, adjudicators_granted: 10, observers_granted: 10,debate_teams_confirmed: 10, adjudicators_confirmed: 10, observers_confirmed: 10) }

  describe 'dashboard numbers are scoped to the current tournament' do 
    it 'should only show you the current tournaments figures' do
      login_for_tournament(t1)
      visit admin_dashboard_path
      columns(find('div.panel_contents tr:nth-child(2)').text).should == ['Debate Teams', '1', '1', '1']
      columns(find('div.panel_contents tr:nth-child(3)').text).should == ['Adjudicators', '2', '1', '0']
      columns(find('div.panel_contents tr:nth-child(4)').text).should == ['Observers', '3', '1', '0']
    end

  end
end

