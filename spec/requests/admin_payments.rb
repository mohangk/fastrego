require 'spec_helper'
require_relative './admin_helpers.rb'

describe 'AdminInstitution' do
  include AdminHelpers

  describe 'create and update payments' do

    let!(:registration) { FactoryGirl.create :registration}

    it 'allows for a payment to be created and edited' do
       
      login
      visit admin_payments_path
      page.should have_content 'Payment'
      click_link 'New Payment'
      select registration.user.institution.name, from: 'Institution'
      fill_in 'Amount sent', with: '120'
      fill_in 'A/C #', with: '987654321' 
      attach_file 'Proof of transfer', File.join(Rails.root, 'spec', 'uploaded_files', 'test_image.jpg') 
      fill_in 'Amount received', with: '100'
      click_button 'Create Payment'
      visit admin_payments_path
      puts page.html
      page.should have_content registration.user.institution.abbreviation
      click_link 'Edit'
      page.should have_select 'Institution', with: registration.user.name 
      page.should have_field 'Amount sent', with: '120.00'
      page.should have_field 'A/C #', with: '987654321'
      page.should have_field 'Amount received', with: '100.00'

      fill_in 'Amount received' , with: '110.00'
      click_button 'Update Payment'
      visit admin_registrations_path
      page.should have_content '110.00'
    end
  end
end

