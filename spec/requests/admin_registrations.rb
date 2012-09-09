require 'spec_helper'
require_relative './admin_helpers.rb'

describe 'AdminRegistration' do
  include AdminHelpers

  let!(:t2) { FactoryGirl.create(:t2_tournament) }
  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com') }
  let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com') }
  let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager) }
  let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager) }

  before :each do
    FactoryGirl.create :debate_team_fees, tournament: t2
    login_for_tournament(t2)
  end

  describe 'registrations associated with this tournament' do

    it 'lists registration for this tournament and allows for those registrations to be viewed and relevant fields edited', js: true do

      visit admin_registrations_path
      team_manager = t2_registration.team_manager

      page.should have_content 'Registration'

      page.should have_content t2_registration.institution.abbreviation
      page.should_not have_content t1_registration.institution.abbreviation
      page.should_not have_content 'New'
      page.should have_content 'View'
      page.should have_content 'Edit'
      page.should have_content 'Delete'

      click_link 'Edit'
      page.should have_field 'Debate teams requested', with: t2_registration.debate_teams_requested.to_s
      page.should have_field 'Adjudicators requested', with: t2_registration.adjudicators_requested.to_s
      page.should have_field 'Observers requested', with: t2_registration.observers_requested.to_s
      
      fill_in 'Debate teams granted', with: 6
      fill_in 'Adjudicators granted', with: 5
      fill_in 'Observers granted', with: 4
      
      fill_in 'Debate teams confirmed', with: 3
      fill_in 'Adjudicators confirmed', with: 2
      fill_in 'Observers confirmed', with: 1

      click_button 'Update Registration'
      visit admin_registrations_path

      page.should have_content t2_registration.institution.abbreviation

      click_link 'Edit'

      page.should have_content t2_registration.tournament.name
      page.should have_select 'Team manager', with: team_manager.name
      page.should have_select 'Institution', with: t2_registration.institution.name

      page.should have_field 'Debate teams granted', with: '6'
      page.should have_field 'Adjudicators granted', with: '5'
      page.should have_field 'Observers granted', with: '4'

      page.should have_field 'Debate teams confirmed', with: '3'
      page.should have_field 'Adjudicators confirmed', with: '2'
      page.should have_field 'Observers confirmed', with: '1'
      page.find('input#registration_fees')['value'].should == '1200.00' 
      check 'registration_override_fees'

      fill_in 'Fees' , with: '639.00'
      click_button 'Update Registration'
      visit admin_registrations_path
      page.should have_content '639.00'

    end

    pending 'it allows deleting  registrations' do
      visit admin_registrations_path
      click_link 'Delete'
      page.should_not have_content t2_registration.institution.abbreviation
    end


  end

  describe 'unassociated registrations' do

    pending 'does not allow the access to a different tournaments registrations' do
      visit edit_admin_registration_path(t1_registration)    
    end

    pending 'does not allow the deleting of a different tournaments registrations'

  end
end

