require 'spec_helper'

describe "Institutions list" do

  let!(:t1) { FactoryGirl.create(:t1_tournament) } 
  let!(:mmu) { FactoryGirl.create(:institution) }

  before(:each) do
    set_subdomain t1.identifier
  end

  pending 'it handles that case when no tournament_identifier is available'

  describe "list" do
    it "provides a list of institutions with a link to create a team manager" do
      dum = FactoryGirl.create(:institution, name: 'Dummy institution', abbreviation: 'DUM')
      visit institutions_path
      page.should have_content('Multimedia University')
      page.should have_content('MMU')
      page.should have_content('Malaysia')
      page.should have_content('http://www.mmu.edu.my')
      page.should have_css("a[href='/registration/new?institution_id=#{mmu.id}']")
      page.should have_link 'Click here to add your institution now'
      click_link "add_team_manager_institution_#{mmu.id}"
    end

    it "displays the name of a team manager if already exists" do
      user = FactoryGirl.create(:user)
      registration = FactoryGirl.create(:registration, institution: mmu, tournament: t1, team_manager: user)
      visit institutions_path
      page.should_not have_css("a[href='/registrations/new?institution_id=#{mmu.id}']")
      page.should have_content('Suthen Thomas')
    end

    describe 'clicking "Add team manager" ' do

      context 'if the team manager has no account' do 
        pending 'forwards to a sign up page or sign in page' do

          visit institutions_path
          click_link "add_team_manager_institution_#{mmu.id}"
          page.should have_content('Sign up')

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
          page.should have_content "Are you sure you would like to register as the team manager of #{mmu.name}for the tournament #{t1.name} ?"
        end
      end
      
      context 'if the team manager has an account but is not logged in' do
          it 'forwards to a  sign in page and confirms the team managers registration' do
            visit institutions_path
            click_link "add_team_manager_institution_#{mmu.id}"
            user = FactoryGirl.create(:user)
            user.confirm!
            page.should have_content('Sign in')
            fill_in 'Email', with: user.email
            fill_in 'Password', with: 'password'
            click_button 'Sign in'
            page.should have_content "Are you sure you would like to register as the team manager of #{mmu.name} for the tournament #{t1.name} ?"
          end
      end

      context 'if the team manager is logged in' do
        it 'confirms the team managers registration' do
            user = FactoryGirl.create(:user)
            user.confirm!
            user_login t1, user.email, user.password
            visit institutions_path
            click_link "add_team_manager_institution_#{mmu.id}"
            page.should have_content "Are you sure you would like to register as the team manager of #{mmu.name} for the tournament #{t1.name} ?"
            click_link "Yes"
            page.should have_content "You have been successfully assigned to be the team manager for #{mmu.name} contingent during the #{t1.name}"
        end
      end
    end
  end

  describe "new" do
    it "provides a form that allows you to add a new institution and redirects upon success to the institutions list" do

      visit institutions_path
      click_link 'Click here to add your institution now'
      page.should have_content('New institution')
      fill_in 'Name', with: 'Universiti Teknologi Malaysia'
      fill_in 'Abbreviation', with: 'UTM'
      fill_in 'Website', with: 'http://www.utm.com'
      select('Malaysia', from: 'Country')
      click_button 'Save'
      page.should have_content('successfully registered')
      page.current_path.should == institutions_path
    end
  end
end
