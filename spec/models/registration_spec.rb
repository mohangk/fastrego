require 'spec_helper'

describe Registration do
  let(:t) { FactoryGirl.create(:t1_tournament) }
  let(:r) { Registration.first }

  before :each do
    FactoryGirl.create(:registration, tournament: t)
    FactoryGirl.create(:debate_team_fees, tournament: t)
    FactoryGirl.create(:adjudicator_fees, tournament: t)
    FactoryGirl.create(:observer_fees, tournament: t)
    FactoryGirl.create(:debate_team_size, tournament: t)
    FactoryGirl.create(:tournament_registration_email, tournament: t)
  end

  it { should belong_to :institution }
  it { should validate_presence_of :institution_id }
  it { should validate_uniqueness_of(:institution_id).scoped_to(:tournament_id) }
  it { should belong_to(:tournament) }
  it { should belong_to :team_manager }
  it { should validate_uniqueness_of(:team_manager_id).scoped_to(:tournament_id) }
  it { should validate_presence_of :team_manager_id }
  it { should validate_presence_of :tournament_id }
  it { should have_many(:payments).dependent(:destroy) }
  it { should have_many(:debaters).dependent(:destroy) }
  it { should have_many(:adjudicators).dependent(:destroy) }
  it { should have_many(:observers).dependent(:destroy) }
  it { should have_many(:participants).dependent(:destroy)}
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
  it { should have_db_column(:fees).of_type(:decimal).with_options(precision:14, scale:2) }


  describe '.tournament_identifier' do

    let!(:t2) { FactoryGirl.create(:t2_tournament) }

    let!(:team_manager1) { FactoryGirl.create(:user, email: 'team_manager1@test.com') }
    let!(:team_manager2) { FactoryGirl.create(:user, email: 'team_manager2@test.com') }

    let!(:r1_t1) { FactoryGirl.create(:registration, tournament: r.tournament, team_manager: team_manager1) }
    let!(:r1_t2) { FactoryGirl.create(:registration, tournament: t2, team_manager: team_manager2) }
    let!(:r2_t2) { FactoryGirl.create(:registration, tournament: t2, team_manager: team_manager1) }

    context 'when user is an admin user' do
      it 'returns the registrations for the specified tournament and admin user' do
          Registration.for_tournament('t2', t2.admin_user).map(&:id).should =~ [r1_t2.id, r2_t2.id]
      end
    end

    context 'when user is a team manager' do
      it 'returns the registrations for the specified tournament and team manager' do
          Registration.for_tournament('t2', team_manager1).map(&:id).should =~ [r2_t2.id]
      end
    end
  end

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
        ActionMailer::Base.deliveries.last.to.should == [r.team_manager.email]
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
      FactoryGirl.create_list(:manual_payment, 5, registration: r, amount_received: 10000)
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

  describe 'paypal payment related payment calculations' do
    before :each do
      FactoryGirl.create_list(:paypal_payment, 5, registration: r, amount_received: 59, amount_sent: 59, fastrego_fees: 9)
      #set one payment as unconfirmed
      r.reload.payments[4].amount_received = nil
      r.payments[4].save
    end

    it 'excludes the paypal fees' do
      r.total_confirmed_payments.to_f.should == 200.0
      r.total_unconfirmed_payments.to_f.should == 50.0
    end
  end

  describe '#confirm_slots' do
    context 'nothing confirmed' do

      it 'should not send a slots_confirmed_notification' do
        ActionMailer::Base.deliveries = []
        r.confirm_slots(nil,nil,nil)
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
        r.confirm_slots(2,1,1)
        ActionMailer::Base.deliveries.last.to.should == [r.team_manager.email]
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
          d.speaker_number.should == index+1
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
  pending 'it should validate that the email is only sent if there are changes to the actual quantities'
  pending 'it should validate that the X_confirmed quantities cannot be set lower then the current amount stored data'
  pending 'debate_teams explodes when the confirmed quantities are not set yet'

  describe '#pre_registration_fees' do
    before do
      r.stub(fees: 200)
      r.tournament.stub(pre_registration_fees_percentage: 10)
    end

    it 'is a portion of the total fees' do
      r.pre_registration_fees.should == 20.00
    end
  end

  describe '#balance_pre_registration_fees' do

    it 'is the result of pre_registration_fees - total_confirmed_payment' do
      r.stub(total_confirmed_payments: 0)
      r.stub(pre_registration_fees: 100)
      r.balance_pre_registration_fees.to_i.should == 100.00

      r.stub(total_confirmed_payments: 20)
      r.stub(pre_registration_fees: 100)
      r.balance_pre_registration_fees.to_i.should == 80.00
    end

    it 'returns 0 instead of -ve values' do
      r.stub(total_confirmed_payments: 120)
      r.stub(pre_registration_fees: 100)
      r.balance_pre_registration_fees.to_i.should == 0.00
    end


  end

end
