require 'spec_helper'

describe "Users" do
  before :each do
    FactoryGirl.create(:currency_symbol)
  end

  describe "sign up" do
    before do
      FactoryGirl.create(:institution)
    end
    it 'provides a form for users to sign up and then forward them to the profile page' do
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
      #we do this because we are using :confirmable module in devise
      User.first.confirm!
      page.should have_content 'You need to sign in'
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'
      page.should have_content 'Signed in successfully'
      page.current_path.should == root_path
    end
  end

  describe 'profile' do

    let!(:user) do
      user = Factory(:user)
      user.confirm!
      user
    end

    before :each do
      Factory(:institution, name: 'Universiti Teknologi', abbreviation: 'UTM')
    end

    context 'before the user is logged in' do
      it 'redirects to sign in page' do
        visit profile_path
        page.current_path.should == new_user_session_path
      end
    end

    context 'once the user is logged in' do

      before :each do
        visit profile_path
        page.should have_content 'You need to sign in'
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password'
        click_button 'Sign in'
        page.current_path.should == profile_path
        page.should have_content 'Signed in successfully'
      end

      describe "top section of the profile page" do

        it 'will have a logout link, upon clicking it logs the user out' do
          visit profile_path
          page.should have_link 'Logout'
          click_link 'Logout'
          page.should have_content 'You need to sign in'
        end

        it 'will display the users information' do
          visit profile_path
          page.should have_content 'Suthen Thomas'
          #page.should have_content 'suthen.thomas@gmail.com'
          page.should have_content 'MMU'
          #page.should have_content '123123123123'
        end

        it 'will have an "Edit profile" link that provides a user with a form to edit their user details' do
          visit profile_path
          page.should have_link 'Edit profile'
          click_link 'Edit profile'
          page.should have_css('a[href="/"]', text: 'Back')
          fill_in 'Email', with: 'test2@test.com'
          fill_in 'Name', with: 'Alex Yoong'
          fill_in 'Current password', with: 'password'
          fill_in 'Password', with: 'password123'
          fill_in 'Password confirmation', with: 'password123'
          fill_in 'Phone number', with: '99999999'
          select 'Universiti Teknologi', from: 'Institution'
          click_button 'Update'
          page.current_path.should == root_path
          page.should have_content 'Alex Yoong'
          page.should have_content 'UTM'
          click_link 'Logout'
          page.should have_content 'You need to sign in'
          fill_in 'Email', with: 'test2@test.com'
          fill_in 'Password', with: 'password123'
          click_button 'Sign in'
          page.current_path.should == root_path
          page.should have_content 'Signed in successfully'
        end
      end

      describe 'submitting pre-registration' do
        context 'once pre-registration is open' do
          before :each do
            Factory(:enable_pre_registration)
          end
          it "will show the pre-registration form which when submitted will save the requested values from the team manager" do
            visit profile_path
            page.should have_content 'Registration is open'
            fill_in 'Debate teams requested', with: 3
            fill_in 'Adjudicators requested', with: 2
            fill_in 'Observers requested', with: 0
            click_button 'Save'
            page.should have_content 'Registration was successful'
          end
        end
      end

      describe 'submitting payment information' do
        context 'once relevant slots have been granted' do
          let!(:user) do
            user = FactoryGirl.create(:registration, debate_teams_granted: 1, fees: 1000).user
            user.confirm!
            user
          end

          it "will show the pre-registration form" do
            page.should have_content 'Total registration fees due RM'
          end

          it "will allow creating a payment" do
            select '2012'
            select 'Feb'
            select '10'
            fill_in 'A/C #', with: 'ABC123'
            fill_in 'RM', with: 1000.50
            fill_in 'Comments', with: 'This is a slightly longer comment then usual'
            attach_file 'payment_scanned_proof', File.join(Rails.root, 'spec', 'uploaded_files', 'test_image.jpg')
            click_button 'Add payment'
            page.current_path.should == profile_path
            page.should have_content 'Payment was successfully recorded.'
            page.should have_content '2012-02-10'
            page.should have_content 'ABC123'
            page.should have_content 'RM1,000.50'
            page.should have_content 'This is a slightly longer comment then usual'
            page.should have_css "a[href*='test_image.jpg']"
          end
        end
      end

    end

  end
end


