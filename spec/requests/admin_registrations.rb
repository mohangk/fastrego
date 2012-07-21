require 'spec_helper'
require_relative './admin_helpers.rb'

describe 'AdminInstitution' do
  include AdminHelpers

  describe 'create and update registrations' do

    let!(:team_manager) { FactoryGirl.create :user}

    it 'allows for a registration to be created and edited', js: true do
      FactoryGirl.create :debate_team_fees
      
      login
      visit admin_registrations_path
      page.should have_content 'Registration'
      click_link 'New Registration'
      select team_manager.name, from: 'Team manager'
      fill_in 'Debate teams requested', with: 9
      fill_in 'Adjudicators requested', with: 8
      fill_in 'Observers requested', with: 7
      
      fill_in 'Debate teams granted', with: 6
      fill_in 'Adjudicators granted', with: 5
      fill_in 'Observers granted', with: 4
      
      fill_in 'Debate teams confirmed', with: 3
      fill_in 'Adjudicators confirmed', with: 2
      fill_in 'Observers confirmed', with: 1

      click_button 'Create Registration'
      visit admin_registrations_path
      page.should have_content team_manager.institution.abbreviation
      click_link 'Edit'
      page.should have_select 'Team manager', with: team_manager.name
      page.should have_field 'Debate teams requested', with: '9'
      page.should have_field 'Adjudicators requested', with: '8'
      page.should have_field 'Observers requested', with: '7'

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
  end
end

