require 'spec_helper'

describe Institution do
  subject { FactoryGirl.create(:institution) }
  it { should have_many(:registrations).dependent(:nullify) }
  it { should ensure_length_of(:abbreviation).is_at_most(10) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:abbreviation) }
  it { should validate_presence_of(:country) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:abbreviation) }

  before(:each) do
    FactoryGirl.create(:institution, name: 'Zztop', abbreviation: 'zz')
    FactoryGirl.create(:institution, name: 'Multimedia University')
    FactoryGirl.create(:institution, name: 'Aatop', abbreviation: 'aa')
    FactoryGirl.create(:institution, name: 'Bbtop', abbreviation: 'cc')
  end

  it "should strip attributes with whitespaces" do
    subject
    lambda {Institution.create!(abbreviation: "#{subject.abbreviation} ", name: 'Fake MMU', country: 'Test')}.should raise_error ActiveRecord::RecordInvalid
  end

  it "should list institutions alphabetically" do

    institutions = Institution.alphabetically
    institutions[0].name.should == 'Aatop'
    institutions[1].name.should == 'Bbtop'
    institutions[2].name.should == 'Multimedia University'
    institutions[3].name.should == 'Zztop'
  end


  describe 'relations to tournament' do
    let(:institution1) { Institution.first }
    let(:institution2) { Institution.last }
    let!(:t2) { FactoryGirl.create(:t2_tournament) }
    let!(:t1) { FactoryGirl.create(:t1_tournament) }
    let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com')}
    let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com')}
    let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager,  institution: institution1) }
    let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager, institution: institution2) }
  
    describe '.participating' do
      it 'only returns institutions participating for a specific tournament' do
        Institution.participating(t1.identifier, t1.admin_user).map(&:id).should =~ [institution1.id]         
      end
    end

    describe '.paid_participating' do 
      it 'returns institutions whose team managers have paid' do
        t2_team_manager2 = FactoryGirl.create(:user, email: 't2_team_manager2@test.com')
        t2_registration_2 = FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager2)
        FactoryGirl.create(:payment, registration: t2_registration) 
        Institution.paid_participating(t2.identifier, t2.admin_user).map(&:id).should =~ [t2_registration.institution.id]         
      end
    end
    
    describe '#is_participating?' do
      it 'returns true if the institution is participating in the tournament' do
        institution2.is_participating?(t1.identifier).should == false        
        institution2.is_participating?(t2.identifier).should == true
      end
    end

    describe '#registration' do
      it 'returns the registration for the institution if participating in the specifictournament' do
        institution2.registration(t1.identifier).should == nil
        institution2.registration(t2.identifier).id.should == t2_registration.id
      end
    end
  end

end
