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
  it { should have_many :payments }
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
        r.reload
        r.debate_teams_granted.should == 1
        r.adjudicators_granted.should == 1
        r.observers_granted.should == 1
      end
    end
    context  "fee not set" do
      it "should calculate the fees if fees param not passed in" do
        r.grant_slots(1,1,1)
        r.reload
        r.fees.should == 400
      end

      it "should calculate fees if blank string passed in as fees param" do
        r.grant_slots(1,1,0,'')
        r.reload
        r.fees.should == 300
      end

      it 'should calculate fees if any of the granted values is an empty string or nil' do
        r.grant_slots(1,1,nil)
        r.reload
        r.fees.should == 300
      end

    end
    context "fee set" do
      it "should set fees based on the fees value" do
        r.grant_slots(1, 1, 1, 100)
        r.reload
        r.fees = 100

        r.grant_slots(1, 1, 0, 0)
        r.reload
        r.fees.should == 0

      end
    end
  end

  describe '#granted?' do
    it 'will return true if any of the *_granted values are set else false' do
      r.granted?.should == false
      r.grant_slots(0,1,0)
      r.granted?.should == true
    end
  end

  describe 'payment related methods' do

    before :each do
      FactoryGirl.create_list(:payment, 5, registration: r, amount_received: 10000)
      #set one payment as unconfirmed
      r.reload.payments[4].amount_received = nil
      r.payments[4].save
    end

    describe '#total_confirmed_payments' do

      it 'will sum up all amount_received of confirmed payments' do
        r.total_confirmed_payments.should == BigDecimal.new('40000')
      end
    end

    describe '#total_unconfirmed_payments' do
        it 'will sum up the amount_sent columns for unconfirmed payments' do
          r.total_unconfirmed_payments.should == BigDecimal.new('12000')
        end
    end
  end

  describe '#confirm_slots' do
    context 'nothing confirmed' do
      it "should not set any values but still return true" do
        r.confirm_slots(nil, nil, nil).should == true
        r.reload
        r.debate_teams_confirmed.should == 0
        r.adjudicators_confirmed.should == 0
        r.observers_confirmed.should == 0
      end
      it "should only set the values that were passed in" do
        r.confirm_slots('', '12', nil).should == true
        r.reload
        r.debate_teams_confirmed.should == 0
        r.adjudicators_confirmed.should == 12
        r.observers_confirmed.should == 0
      end
    end
  end

  describe '#confirmed' do
    it 'will return true if any of the *_granted values are set else false' do
      r.confirmed?.should == false
      r.confirm_slots(0,1,0)
      r.confirmed?.should == true
    end
  end

end
