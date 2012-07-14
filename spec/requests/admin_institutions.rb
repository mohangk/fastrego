require 'spec_helper'
require_relative './admin_helpers.rb'

describe 'AdminInstitution' do
  include AdminHelpers

  describe 'create and edit institution' do
    it 'allows for an institution to be created' do
      login
      visit admin_institutions_path
      page.should have_content 'Institutions'
      click_link 'New Institution'
      fill_in 'Name',  with: 'Test institution'
      fill_in 'Abbreviation', with: 'TEST'
      fill_in 'Website', with: 'http://test.com'
      select 'Malaysia', from: 'Country'
      click_button 'Create Institution'
      visit admin_institutions_path
      page.should have_content 'Test institution'
      click_link 'Edit'
      page.has_field? 'Name', with: 'Test institution' 
    end
  end
end

