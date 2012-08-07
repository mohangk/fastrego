require 'spec_helper'
require_relative './admin_helpers.rb'

describe 'AdminInstitution' do
  include AdminHelpers

  describe 'create and edit team manager' do

    let!(:institution) { FactoryGirl.create :institution }

    it 'allows for a team manager to be created and edited' do
      t1 = FactoryGirl.create(:t1_tournament)
      set_subdomain 't1'
      login
      visit admin_users_path
      page.should have_content 'Team manager'
      click_link 'New User'
      select institution.name, from: 'Institution'
      fill_in 'Name',  with: 'Test team manager'
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password' 
      fill_in 'Phone number', with: '123123123'
      click_button 'Create User'
      visit admin_users_path
      page.should have_content 'Test team manager'
      click_link 'Edit'
      page.has_field? 'Name', with: 'Test team manager' 
      fill_in 'Name', with: 'Test team 2 manager'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password' 
      click_button 'Update User'
      visit admin_users_path
      page.should have_content 'Test team 2 manager'
    end
  end
end

