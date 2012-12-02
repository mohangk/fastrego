require 'spec_helper'

describe 'AdminParticipant' do
  let!(:t2) { FactoryGirl.create(:t2_tournament) }
  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com') }
  let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com') }
  let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager) }
  let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager) }

  before :each do
    FactoryGirl.create(:debater, registration: t2_registration)
    FactoryGirl.create(:observer, registration: t1_registration)
    login_for_tournament(t2)
    visit admin_participants_path
  end

  describe 'participants index' do

    it 'only lists participants associated with this tournament' do
      page.should have_content 'Participants'
      page.should have_content 'Jack Nostrum'
      page.should have_content 'Debater'
      page.should_not have_content 'Jack Observer'
    end

    pending 'only lists team managers who have registrations in the select'
    pending 'only list institutions that have registrations in the select'

  end

  describe 'view participant data' do
    pending 'form only lists institutions who have registrations for this tournament'

    it 'allows for participant data to be viewed' do
      click_link 'View'
      page.should have_content 'Jack Nostrum'
    end

  end
end

