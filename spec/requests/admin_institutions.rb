require 'spec_helper'

describe 'AdminInstitution' do
  before :each do
    FactoryGirl.create(:admin_user)
  end

  def login
    visit admin_dashboard_path
    page.should have_content 'Login'
    fill_in 'Email', with: 'admin@test.com'
    fill_in 'Password', with: 'password'
    click_button 'Login'
  end

  describe 'create institution' do
    it 'allows for an institution to be created' do
      login
      visit admin_institutions_path
      page.should have_content 'Institutions'
      click_link 'New Institution'
    end
  end
end

