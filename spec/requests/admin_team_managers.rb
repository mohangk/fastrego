require 'spec_helper'
require_relative './admin_helpers.rb'

describe 'AdminInstitution' do
  include AdminHelpers

  describe 'create and edit team manager' do

    let!(:t2) { FactoryGirl.create(:t2_tournament) }
    let!(:t1) { FactoryGirl.create(:t1_tournament) }
    let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com') }
    let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com') }
    let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager) }
    let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager) }

    it 'only list team managers who have registered for this tournament to be only viewed, not edit, deleted or created' do
      login_for_tournament(t1)
      visit admin_users_path
      page.should have_content 'Team manager'

      visit admin_users_path
      page.should_not have_content t2_team_manager.email
      page.should have_content t1_team_manager.email

      page.should_not have_content 'New'
      page.should_not have_content 'Edit'
      page.should_not have_content 'Delete'
      click_link 'View'
      page.should have_content t1_team_manager.name
    end
  end
end

