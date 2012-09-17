require 'spec_helper'
require_relative './admin_helpers.rb'

describe 'AdminInstitution' do
  include AdminHelpers

  let!(:t2) { FactoryGirl.create(:t2_tournament) }
  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com') }
  let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com') }
  let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager) }
  let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager) }

  describe 'payments index' do
    pending 'only lists team managers who have submitted payments in the select'
    pending 'only list institutions that have submitted payments in the select'
  end

  describe 'create and update payments' do
    pending 'form only lists institutions who have registrations for this tournament'

    it 'allows for a payment to be created and edited and deleted' do
      registration = t2_registration
      login_for_tournament(t2)
      visit admin_payments_path
      page.should have_content 'Payment'
      click_link 'New Payment'
      select registration.institution.name, from: 'Institution'
      fill_in 'Amount sent', with: '120'
      fill_in 'A/C #', with: '987654321' 
      attach_file 'Proof of transfer', File.join(Rails.root, 'spec', 'uploaded_files', 'test_image.jpg') 
      fill_in 'Amount received', with: '100'
      click_button 'Create Payment'
      visit admin_payments_path
      page.should have_content registration.institution.abbreviation
      click_link 'Edit'
      page.should have_select 'Institution', with: registration.team_manager.name 
      page.should have_field 'Amount sent', with: '120.00'
      page.should have_field 'A/C #', with: '987654321'
      page.should have_field 'Amount received', with: '100.00'

      fill_in 'Amount received' , with: '110.00'
      click_button 'Update Payment'
      visit admin_registrations_path
      page.should have_content '110.00'

      page.should have_content 'Delete'
      click_link 'Delete'
      page.should_not have_content '110.00'
    end

  end
end

