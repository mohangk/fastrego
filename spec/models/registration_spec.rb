require 'spec_helper'

describe Registration do
  let(:r) {Registration.first}

  before :each do
    Factory(:registration)
    Factory(:debate_team_fees)
    Factory(:adjudicator_fees)
    Factory(:observer_fees)
  end
  it { should belong_to :user }
  it { should validate_uniqueness_of :user_id }
  it { should validate_presence_of :user_id}
  it { should validate_numericality_of(:debate_teams_requested)}
  it { should validate_numericality_of(:adjudicators_requested)}
  it { should validate_numericality_of(:observers_requested)}
  it { should validate_numericality_of(:debate_teams_granted)}
  it { should validate_numericality_of(:adjudicators_granted)}
  it { should validate_numericality_of(:observers_granted)}
  it { should validate_numericality_of(:debate_teams_confirmed)}
  it { should validate_numericality_of(:adjudicators_confirmed)}
  it { should validate_numericality_of(:observers_confirmed)}
  it { should_not allow_mass_assignment_of(:debate_teams_granted)}
  it { should_not allow_mass_assignment_of(:adjudicators_granted)}
  it { should_not allow_mass_assignment_of(:observers_granted)}
  it { should_not allow_mass_assignment_of(:debate_teams_confirmed)}
  it { should_not allow_mass_assignment_of(:adjudicators_confirmed)}
  it { should_not allow_mass_assignment_of(:observers_confirmed)}
  it { should validate_numericality_of(:fees)}

  describe "#grant_slots" do

    context "granting 1 dt, 1 adj, 1 obs" do
     it "should set all values" do
        r.grant_slots(1,1,1)
        r = Registration.first
        r.debate_teams_granted.should == 1
        r.adjudicators_granted.should == 1
        r.observers_granted.should == 1
      end
    end
    context  "fee not set" do
      it "should calculate the fees" do
        r.grant_slots(1,1,1)
        r = Registration.first
        r.fees.should == 400

        r.grant_slots(1,1,0,'')
        r = Registration.first
        r.fees.should == 300
      end

    end
    context "fee set" do
      it "should set fees based on the fees value" do
        r.grant_slots(1, 1, 1, 100)
        r = Registration.first
        r.fees = 100

        r.grant_slots(1, 1, 0, 0)
        r = Registration.first
        r.fees.should == 0

      end
    end
  end

  describe '#granted?' do
    it 'will return true if any of the *_granted values are set else false' do
      puts r.inspect
      r.granted?.should == false
      r.grant_slots(0,1,0)
      r.granted?.should == true
    end
  end

end
