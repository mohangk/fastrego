require 'spec_helper'

describe "Users" do
  describe "sign up" do

    it 'provides a form for users to sign up', do
      visit profile_path
      page.should have_content 'You need to sign in'
      page.should have_link 'Sign up'
      click_link 'Sign up'
      page.should have_content 'Sign up'
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      select 'Multimedia University', from: 'Institution'
      fill_in 'Phone number', with: '012123123123'
      click_button 'Sign up'
    end
  end



end
