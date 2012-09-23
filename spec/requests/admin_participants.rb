require 'spec_helper'
require_relative './admin_helpers.rb'

describe 'AdminTeamManager' do
  include AdminHelpers

  describe 'associated team managers' do

    let!(:t2) { FactoryGirl.create(:t2_tournament) }
    let!(:t1) { FactoryGirl.create(:t1_tournament) }
    let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com') }
    let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com') }
    let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager) }
    let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager) }

    it 'can only be listed and viewed' do

      login_for_tournament(t1)
      visit admin_participants_path

      page.should have_content 'Participants'
    end

    pending 'it only shows participants for this specific tournament'
  end
end

