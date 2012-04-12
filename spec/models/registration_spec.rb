require 'spec_helper'

describe Registration do
  let(:r) {Registration.first}

  before :each do
    FactoryGirl.create(:registration)
    FactoryGirl.create(:debate_team_fees)
    FactoryGirl.create(:adjudicator_fees)
    FactoryGirl.create(:observer_fees)
    FactoryGirl.create(:debate_team_size)
  end
  it { should belong_to :user }
  it { should have_many :payments }
  it { should have_many :debaters }
  it { should have_many :adjudicators }
  it { should have_many :observers }
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
    context 'nothing set' do
      it 'should not send a slots_granted_notification' do

        ActionMailer::Base.deliveries = [] 
        r.grant_slots(nil,nil,nil)
        ActionMailer::Base.deliveries.last.should == nil
      end
      it 'should not set any values' do
        r.grant_slots(nil,nil,nil)
        r.debate_teams_granted.should == nil
        r.adjudicators_granted.should == nil
        r.observers_granted.should == nil
      end
      it 'should not set any values' do
        r.grant_slots('','','')
        r.debate_teams_granted.should == nil
        r.adjudicators_granted.should == nil
        r.observers_granted.should == nil
      end
    end
    context "granting 1 dt, 1 adj, 1 obs" do

      it 'should send a slots_granted_notification' do
        ActionMailer::Base.deliveries = [] 
        r.grant_slots(1,1,1)
        ActionMailer::Base.deliveries.last.to.should == [r.user.email]
      end

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

      it 'should not send a slots_confirmed_notification' do
        ActionMailer::Base.deliveries = [] 
        r.confirm_slots(1,1,1)
        ActionMailer::Base.deliveries.last.should == nil
      end

      it "should not set any values but still return true" do
        r.confirm_slots(nil, nil, nil).should == true
        r.reload
        r.debate_teams_confirmed.should == nil
        r.adjudicators_confirmed.should == nil
        r.observers_confirmed.should == nil
      end
      it "should not set any values but still return true" do
        r.confirm_slots('', '', '').should == true
        r.reload
        r.debate_teams_confirmed.should == nil
        r.adjudicators_confirmed.should == nil
        r.observers_confirmed.should == nil
      end
    end
    context 'something confirmed' do
      
      it 'should send a slots_granted_notification' do
        ActionMailer::Base.deliveries = [] 
        r.confirm_slots(1,1,1)
        ActionMailer::Base.deliveries.last.to.should == [r.user.email]
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

  describe '#confirmed?' do
    it 'will return true if any of the *_granted values are set else false' do
      r.confirmed?.should == false
      r.confirm_slots(0,1,0)
      r.confirmed?.should == true
    end
  end

  describe '#debate_teams' do

    before :each do
      r.debate_teams_confirmed = 2
    end
    
    context 'no debaters created' do
      it 'returns an array of array of new debaters' do
        r.debate_teams.count.should == 2
        r.debate_teams.each_with_index { |team, index|
          team.each do |d|
            d.team_number.should == index + 1
            d.should be_an_instance_of(Debater)
            d.persisted?.should == false
          end
        }        
      end
    end


    context '2nd speaker team 1 and 1st and 3rd speaker team 2 created' do
      before :each do
        @second_t2 = FactoryGirl.create(:debater, registration: r, name: '2nd speaker team 2', speaker_number: 2, team_number: 2)
        @first_t2 = FactoryGirl.create(:debater, registration: r, name: '1st speaker team 2', speaker_number: 1, team_number: 2)
        @third_t1 = FactoryGirl.create(:debater, registration: r, name: '3rd speaker team 1', speaker_number: 3, team_number: 1)
      end

      it 'returns 2 teams' do
         r.debate_teams.length.should == 2
      end

      it 'contains the relevant team_number and speaker_number' do
        r.debate_teams[0].each_with_index do |d, index|
          d.team_number.should == 1
          d.speaker_number.should == index+1
        end

        r.debate_teams[1].each_with_index do |d, index|
          d.team_number.should == 2
          d.speaker_number.should == index +1
        end
      end

      it 'contains the persisted 3rd speaker of team1' do
        r.debate_teams[0].length.should == 3
        r.debate_teams[0].should include @third_t1
      end

      it 'contains the persisted 1st and 2nd speaker of team2' do
        r.debate_teams[1].length.should == 3
        r.debate_teams[1].should include @first_t2, @second_t2
      end

    end

  end

  pending 'it should validate that the X_confirmed quantities cannot be set lower then the current amount stored data'

end
