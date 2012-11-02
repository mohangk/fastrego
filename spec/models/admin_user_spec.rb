require 'spec_helper'

describe AdminUser do

  it { should have_many(:tournaments).dependent(:nullify) }
  it { should have_many(:registrations) }

  let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager) }
  let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager) }

  let!(:t2) { FactoryGirl.create(:t2_tournament) } 
  let!(:t1) { FactoryGirl.create(:t1_tournament) }

  let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com') } 
  let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com') } 


  describe 'registrations' do
    it 'returns registrations associated with this admin_user' do
      t1.admin_user.registrations.length.should == 1
      t1.admin_user.registrations.map(&:id).should =~ [t1_registration.id]
    end
  end

  describe 'team_managers' do
    it 'returns team managers associated with this admin_user' do
      t1.admin_user.team_managers.length.should == 1
      t1.admin_user.team_managers.map(&:id).should =~ [t1_team_manager.id]
    end
  end
end
