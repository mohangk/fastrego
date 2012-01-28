require 'spec_helper'

describe "Users" do
  describe "sign up" do
    before do
      Factory(:institution)
    end
    it 'provides a form for users to sign up the forward them to the profile page', do
      visit profile_path
      page.should have_content 'You need to sign in'
      page.should have_link 'Sign up'
      click_link 'Sign up'
      page.should have_content 'Sign up'
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Name', with: 'Jojoman'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      select 'Multimedia University', from: 'Institution'
      fill_in 'Phone number', with: '012123123123'
      click_button 'Sign up'
      page.should_not have_content 'error'
      page.should have_content 'signed up successfully'
      page.current_path.should == profile_path
    end
  end

  describe 'profile' do
    before do
      Factory(:user)
    end

    it 'allows a user that is logged in to be able to see his '
  end



end
