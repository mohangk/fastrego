require 'spec_helper'

describe "Users" do

  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:currency_symbol) { FactoryGirl.create(:currency_symbol, tournament: t1) }
  let!(:mmu) { FactoryGirl.create(:institution) }
  let!(:utm) { FactoryGirl.create(:institution, name: 'Universiti Teknologi', abbreviation: 'UTM') }

  before(:each) do
    set_subdomain t1.identifier
  end

  describe "sign up" do

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

  describe 'tournament profile' do

    let!(:user) do
      user = FactoryGirl.create(:user)
      user.confirm!
      user
    end

    context 'before the user is logged in' do
      it 'redirects to sign in page' do
        visit profile_path
        page.current_path.should == new_user_session_path
      end
    end

    context 'once the user is logged in' do

      before :each do
        user_login(t1, user.email, 'password')
      end

      it 'will have a logout link, upon clicking it logs the user out' do
        visit profile_path
        page.should have_link 'Logout'
        click_link 'Logout'
        page.should have_content 'You need to sign in'
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
        click_button 'Update profile'
        page.current_path.should == root_path
        page.should have_content 'You updated your account successfully.'
        page.should have_content 'Alex Yoong'
        click_link 'Logout'
        page.should have_content 'You need to sign in'
        fill_in 'Email', with: 'test2@test.com'
        fill_in 'Password', with: 'password123'
        click_button 'Sign in'
        page.current_path.should == root_path
        page.should have_content 'Signed in successfully'
      end

      context 'before assigning himself as the team manager' do
        it 'displays a notice informing the user as such' do
          page.should have_content 'You are currently not assigned as a team manager for this tournament.'
        end
      end

      context 'after being assigned as the team manager' do

        describe "top section of the profile page" do

          before :each do
            FactoryGirl.create :registration, institution: mmu, tournament: t1, team_manager: user 
            visit profile_path
          end

          it 'will display the users information' do
            page.should have_content 'Suthen Thomas'
            page.should have_content "You are assigned as the team manager for the #{mmu.name} contingent to the #{t1.name}"
          end

        end

        describe 'submitting pre-registration' do
          before :each do
            FactoryGirl.create(:enable_pre_registration, tournament: t1)
            FactoryGirl.create :registration, institution: mmu, tournament: t1, team_manager: user 
            visit profile_path
          end

          it "will show the pre-registration form which when submitted will save the requested values from the team manager" do
            page.should have_content 'Registration is open'
            fill_in 'Debate teams requested', with: 3
            fill_in 'Adjudicators requested', with: 2
            fill_in 'Observers requested', with: 0
            click_button 'Save'
            page.should have_content 'You have successfully requested teams!'
            page.should have_content 'You completed pre-registration at'
          end
        end

        describe 'submitting payment information' do

          def add_payment date
            select date.year.to_s
            select date.strftime '%b'
            select date.day.to_s
            fill_in 'A/C #', with: 'ABC123'
            fill_in 'RM', with: 1000.50
            fill_in 'Comments', with: 'This is a slightly longer comment then usual'
            attach_file 'payment_scanned_proof', File.join(Rails.root, 'spec', 'uploaded_files', 'test_image.jpg')
            click_button 'Add payment'
          end

          before :each do
            FactoryGirl.create :granted_registration, institution: mmu, tournament: t1, team_manager: user 
            visit profile_path
          end

          it "will show the pre-registration form" do
            page.should have_content 'Total registration fees due RM'
          end

          it "will allow creating a payment" do
            date = Date.today
            add_payment date
            page.current_path.should == profile_path
            page.should have_content 'Payment was successfully recorded.'
            page.should have_content date.strftime '%Y-%m-%d'
            page.should have_content 'ABC123'
            page.should have_content 'RM1,000.50'
            page.should have_content 'This is a slightly longer comment then usual'
            page.should have_css "a[href*='test_image.jpg']"
          end

          it 'allows payments to be deleted' do
            add_payment Date.today
            within 'section#payment' do
              click_link 'Delete'
            end
            page.should have_content 'Payment was removed.'
            page.should_not have_content 'RM1,000.50'
          end

          it 'allows payment proof to be viewed' do
            add_payment Date.today
            within 'section#payment' do
              click_link 'View'
              page.current_url.should =~ /test_image.jpg/
            end
          end
        end

        describe 'adding details' do
          before :each do
            FactoryGirl.create :debate_team_size, tournament: t1
            FactoryGirl.create :confirmed_registration, institution: mmu, tournament: t1, team_manager: user 
            visit profile_path
          end

          it 'allows debate team details to be added' do
            tournament = TournamentRegistration.new.tap { |t| t.visit }
            debate_team_form = tournament.add_debate_team_details
            debate_team_form.correct_page?
          end
        end
      end

    end

  end
end


