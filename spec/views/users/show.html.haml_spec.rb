require 'spec_helper'


describe "users/show.html.haml" do

  let(:user) do
    FactoryGirl.create(:user)
  end

  before(:each) do
    user.confirm!
    sign_in user
    view.extend MockHelperMethods
  end

  describe "registration section" do

    it "is closed by default" do
      @registration = Registration.new
      render
      rendered.should have_content('Registration is currently closed')
    end

    context 'when when the system setting "enable_pre_registration" is enabled' do

      before(:each) do
        MockHelperMethods.set_pre_registration_enabled(true)
      end

      context('before the user has been assigned as a team manager') do

        before :each do
          @registration = Registration.new
          render
        end

        it "will tell the team manager that the registration is open" do
          rendered.should_not have_content('Registration is currently closed')
          rendered.should have_content('Registration is open')
        end

        it "tells the team manager that he should register for the tournament" do
          rendered.should have_content('You are currently not assigned as a team manager for this tournament')
        end

        it "hides the registration form" do
          rendered.should_not have_css('input#registration_debate_teams_requested')
          rendered.should_not have_css('input#registration_adjudicators_requested')
          rendered.should_not have_css('input#registration_observers_requested')
        end
      end

      context 'after the user has been assigned as a team manager' do

        before :each do
          @registration = FactoryGirl.create(:registration, team_manager: user)
          render
        end

        it "will recognise user as the team manager" do
          rendered.should have_content("You are assigned as the team manager for the #{@registration.institution.name} contingent to the MMU Worlds")
        end
        
        it 'will provide the registration form' do
          rendered.should have_css('input#registration_debate_teams_requested')
          rendered.should have_css('input#registration_adjudicators_requested')
          rendered.should have_css('input#registration_observers_requested')
        end
      end
    end

    context 'once the team manager has submitted the requested quantities' do

      before :each do
        @registration = FactoryGirl.create(:requested_registration, team_manager: user)
        render
      end

      it 'will display the datetime that the registration was requested' do
        rendered.should have_content('You completed pre-registration at 2011-01-01 01:01:01 +0800 and requested the following slots')
      end

      it "will hide the 3 text boxes to fill in the team managers  requests" do
        rendered.should_not have_css('input#registration_debate_teams_requested')
        rendered.should_not have_css('input#registration_adjudicators_requested')
        rendered.should_not have_css('input#registration_observers_requested')
      end

      it 'will display the registration details' do
        rendered.should have_content('3 debate teams')
        rendered.should have_content('1 adjudicator')
        rendered.should have_content('1 observer')
      end
    end
  end

  describe "granted slots section" do

    before :each do
      @payment = Payment.new
    end

    it "is closed by default" do
      @registration = FactoryGirl.create(:requested_registration, team_manager: user)
      render
      rendered.should_not have_content('You have been granted the following slots')
    end

    it "is displayed when the registration has been granted slots" do
      @registration = FactoryGirl.create(:granted_registration, team_manager: user)
      render
      rendered.should have_content('You have been granted the following slots')
      rendered.should have_content('1 debate team')
    end

  end

  describe "payment details section" do

    before :each do
    end

    it "is closed by default" do
      @registration = FactoryGirl.create(:requested_registration, team_manager: user)
      render
      rendered.should_not have_content('Total registration fees due')
      rendered.should_not have_css('form#new_payment')
    end

    context 'when the registration has a fees associated with it' do

      before :each do
        @registration = FactoryGirl.create(:requested_registration, team_manager: user, fees: 2000)
        #required by _form_payment.html.haml
        @payment = Payment.new
      end

      it "is displayed " do
        payment = FactoryGirl.create(:manual_payment, amount_sent: 1000, amount_received: 999.48, registration: @registration)
        @registration.reload

        user.reload
        render
        rendered.should have_content 'Total registration fees due RM2,000.00'
        rendered.should have_content 'Total confirmed payments RM999.48'
        rendered.should have_content 'Balance fees due RM1,000.52'
        rendered.should have_content 'Total unconfirmed payments RM0.00'
        rendered.should_not have_content 'PayPal'
        rendered.should have_css 'form#new_payment'
      end

      context 'when PayPal is enabled' do

        before(:each) do
          MockHelperMethods.paypal_payment_enabled = true
        end

        it 'has a pay via PayPal link' do 
          render
          rendered.should have_content 'PayPal'
        end
       end
    end

  end

  describe "confirmed slot section" do

    before :each do
      @payment = Payment.new
    end

    it "is closed by default" do
      @registration = FactoryGirl.create(:granted_registration, team_manager: user)
      render
      rendered.should_not have_content('The following slots are confirmed.')
    end

    context 'when debaters, adjudicators and observers are confirmed' do
      it "displays the confirmed amounts and links to add the details" do
        @registration = FactoryGirl.create(:granted_registration, team_manager: user, fees: 2000)
        @payment = Payment.new
        @registration.confirm_slots(9,9,9)
        user.reload
        render
        rendered.should have_content('9 debate teams')
        rendered.should have_content('9 adjudicators')
        rendered.should have_content('9 observers')
        rendered.should have_link('Add debate team details')
        rendered.should have_link('Add adjudicator details')
        rendered.should have_link('Add observer details')
      end
    end

    context 'when only debaters are confirmed' do
      it "only displays the confirmed and links to add details for debaters " do
        @registration = FactoryGirl.create(:granted_registration, team_manager: user, fees: 2000)
        @payment = Payment.new
        @registration.confirm_slots(9,nil,nil)
        user.reload
        render
        Capybara.string(rendered).find('section#confirmed_slots').tap do |confirmed_slots|
          confirmed_slots.should have_content('9 debate teams')
          confirmed_slots.should have_content('0 adjudicators')
          confirmed_slots.should have_content('0 observers')
          confirmed_slots.should have_link('Add debate team details')
          confirmed_slots.should_not have_link('Add adjudicator details')
          confirmed_slots.should_not have_link('Add observer details')
        end
      end
    end

    pending 'should change Add XXX details to Manage XXX details if data has already been saved'
  end
end
