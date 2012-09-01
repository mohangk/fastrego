require 'spec_helper'
require_relative './admin_helpers.rb'

describe 'AdminLogin' do
  include AdminHelpers
  describe 'the subdomain determines the tournament the admin is trying to administrate' do 

    it 'raises an error if the admin tries to access a subdomain that does not exist' do
        t1 = FactoryGirl.create(:t1_tournament)
        set_subdomain 't3'
        login t1.admin_user.email, t1.admin_user.password
        page.should have_content 'Invalid email or password'
    end

    it 'raises an error if the admin tries to access a subdomain that he does not have permission for' do
        t2 = FactoryGirl.create(:t2_tournament)
        set_subdomain 't1'
        login t2.admin_user.email, t2.admin_user.password
        page.should have_content 'Invalid email or password'
    end

    context 'login as admin for t1.test.com' do

        let!(:t2) { FactoryGirl.create(:t2_tournament) }
        let!(:t1) { FactoryGirl.create(:t1_tournament) }
        let!(:t3) { FactoryGirl.create(:t1_tournament, admin_user: t1.admin_user, name: 'tournament 3', identifier: 't3' ) }
        let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com') }
        let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com') }
        let!(:t3_team_manager) { FactoryGirl.create(:user, email: 't3_team_manager@test.com') }
        let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager) }
        let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager) }
        let!(:t3_registration) { FactoryGirl.create(:registration, tournament: t3, team_manager: t3_team_manager) }

      it 'displays the login page' do
        set_subdomain 't1'
        login t1.admin_user.email, t1.admin_user.password
        page.should_not have_content 'Invalid email or password'
      end

      it 'lists team managers related to t1 only' do
        set_subdomain 't1'
        login t1.admin_user.email, t1.admin_user.password
        page.should_not have_content 'Invalid email or password'
        visit admin_users_path
        page.should_not have_content t2_team_manager.email
        page.should have_content t1_team_manager.email
      end

      it 'lists registrations related to t1 only' do
        set_subdomain 't1'
        login t1.admin_user.email, t1.admin_user.password
        visit admin_registrations_path
        page.should_not have_content t2_registration.institution.abbreviation
        page.should_not have_content t3_registration.institution.abbreviation
        page.should have_content t1_registration.institution.abbreviation
      end
    end

  end
end
