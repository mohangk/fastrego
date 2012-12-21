require 'spec_helper'

describe Institution do

  let!(:t2) { FactoryGirl.create(:t2_tournament) }
  let!(:t1) { FactoryGirl.create(:t1_tournament) }

  subject { FactoryGirl.create(:institution, abbreviation: 'new') }

  it { should have_many(:registrations).dependent(:nullify) }

  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:abbreviation) }
  it { should validate_presence_of(:country) }

  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:abbreviation) }

  it { should ensure_length_of(:abbreviation).is_at_most(10) }

  describe "type column values" do
    it "should allow valid values" do
      Institution::SUBCLASSES.each do |v|
        should allow_value(v).for(:type)
      end 
    end

    it "should disallow invalid values" do
      should_not allow_value('bobo').for(:type) 
    end
  end

  before(:each) do
    FactoryGirl.create(:institution, name: 'Zztop', abbreviation: 'zz')
    FactoryGirl.create(:open_institution, name: 'Multimedia University', type: 'OpenInstitution', tournament: t1 )
    FactoryGirl.create(:open_institution, name: 'Aatop', abbreviation: 'aa', type: 'OpenInstitution', tournament: t2)
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
  
  describe '.for_tournament' do
    
    let(:tournament_identifier) { t1.identifier }
    subject(:institutions_for_tournament) { Institution.for_tournament(tournament_identifier) }
    
    context 'when t1 is the passed in tournament identifier' do
      
      it "should include institutions with tournaments set to t1" do
        institutions_for_tournament.map(&:id).should include *Institution.where(tournament_id: t1.id).map(&:id)
      end
    
      it "should not include institutions which are explicitly for different tournaments" do
        institutions_for_tournament.map(&:id).should_not include *Institution.where(tournament_id: t2.id).map(&:id)
      end
    
      it "should include non tournament specific institutions" do
        institutions_for_tournament.map(&:id).should include *Institution.where(tournament_id: nil).map(&:id)
      end
      
    end
  end

  describe 'relations to tournament' do
    let(:institution1) { Institution.first }
    let(:institution2) { Institution.last }
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
