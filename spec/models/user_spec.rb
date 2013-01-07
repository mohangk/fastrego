require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email}
  it { should have_many(:managed_registrations) }

  let!(:t2) { FactoryGirl.create(:t2_tournament) }
  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com')}
  let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com')}
  let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager) }
  let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager) }

  describe '.team_managers' do
    it 'returns team managers for a specific tournament and admin user' do
      User.team_managers(t1.identifier, t1.admin_user).map(&:id).should =~ [t1_team_manager.id] 
      User.team_managers(t1.identifier, t2.admin_user).length.should == 0
    end
  end


  describe '.paid_team_managers' do
    it 'returns users who have made any payment for a specific tournament' do
      t2_team_manager2 = FactoryGirl.create(:user, email: 't2_team_manager2@test.com')
      t2_registration_2 = FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager2)
      FactoryGirl.create(:manual_payment, registration: t2_registration) 
      User.paid_team_managers(t2.identifier, t2.admin_user).map(&:id).should =~ [t2_team_manager.id]
    end
  end
end
