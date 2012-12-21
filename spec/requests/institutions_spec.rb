require 'spec_helper'

describe "Institutions list" do

  let!(:t1) { FactoryGirl.create(:t1_tournament) } 
  let!(:t2) { FactoryGirl.create(:t2_tournament) } 
  let!(:mmu) { FactoryGirl.create(:institution) }

  before(:each) do
    set_subdomain t1.identifier
  end

  pending 'it handles the case when no tournament_identifier is available'

  describe "list" do
    it "provides a list of institutions with a link to create a team manager" do
      dum = FactoryGirl.create(:institution, name: 'Dummy institution', abbreviation: 'DUM')
      
      institutions_page = InstitutionsPage.new.tap { |p| p.visit }
      institutions_page.should have_add_institution_link
      institutions_page.should have_institution dum
      institutions_page.should_not have_team_manager dum
    end

    it "displays the name of a team manager if already exists" do
      user = FactoryGirl.create(:user)
      registration = FactoryGirl.create(:registration, institution: mmu, tournament: t1, team_manager: user)
      institutions_page = InstitutionsPage.new.tap { |p| p.visit }
      institutions_page.should have_team_manager mmu, registration.team_manager.name
    end

    describe 'clicking "Add team manager" ' do

      context 'if the team manager has no account' do 

        pending 'forwards to a sign up page or sign in page where the team manager can sign in that ends with a tewam manager association confirmation'

      end

      context 'if the team manager has an account but is not logged in' do
          it 'forwards to a  sign in page and confirms the team managers registration' do

            user = FactoryGirl.create(:user)
            user.confirm!

            institutions_page = InstitutionsPage.new.tap { |p| p.visit }
            institutions_page.add_team_manager mmu

            page.should have_content('Sign up')
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

            institutions_page = InstitutionsPage.new.tap { |p| p.visit }
            institutions_page.add_team_manager mmu

            page.should have_content "Are you sure you would like to register as the team manager of #{mmu.name} for the tournament #{t1.name} ?"
            click_link "Yes"
            page.should have_content "You have been successfully assigned to be the team manager for #{mmu.name} contingent during the #{t1.name}"
        end
      end
    end
  end

  describe "new" do
    it "provides a form that allows you to add a new institution and redirects upon success to the institutions list" do
      institutions_page = InstitutionsPage.new.tap { |p| p.visit }
      original_institution_count = institutions_page.institution_count
      form = institutions_page.add_institution
      institutions_page = form.fill_details
      institutions_page.institution_count.should == original_institution_count + 1
    end

    context 'open institution' do
      
      it 'is visible only in the tournament it was created for' do

        institutions_page = InstitutionsPage.new.tap { |p| p.visit }
        form = institutions_page.add_institution 
        institutions_page = form.fill_details name: 'Test Open Institution', type: 'OpenInstitution'
        institutions_page.should have_content 'Open Institution'

        set_subdomain t2.identifier

        institutions_page = InstitutionsPage.new.tap { |p| p.visit }
        institutions_page.should_not have_content 'Open Institution'
      end
    end
  end
end
