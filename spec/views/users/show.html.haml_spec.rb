require 'spec_helper'

describe "users/show.html.haml" do

  let(:user) do
    FactoryGirl.create(:user)
  end
  before(:each) do
    user.confirm!
    sign_in user
    @registration = Registration.new
  end



  describe "registration section" do

    it "is closed by default" do
      render
      rendered.should have_content('Registration is currently closed')
    end

    context('when when the system setting "enable_pre_registration" is enabled') do
      before(:each) do
        Setting.stub!(:key).and_return('True')
        render
      end
      context('before the team manager has submitted his registration') do
        it "will tell the team manager that the registration is open" do
          rendered.should_not have_content('Registration is currently closed')
          rendered.should have_content('Registration is open')
        end
        it "will provide 3 text boxes to fill in the team managers  requests" do
          rendered.should have_css('input#registration_debate_teams_requested')
          rendered.should have_css('input#registration_adjudicators_requested')
          rendered.should have_css('input#registration_observers_requested')
        end
      end

      context('after the team manager has submitted his registration ') do
        let(:user) do
          user = FactoryGirl.create(:user)
          user.confirm!
          registration = FactoryGirl.create(:registration, user: user)
          user.registration = registration
          user
        end

        it 'will not provide the registration form' do
          rendered.should_not have_css('form#new_registration')
        end

        it 'will display the datetime that the registration was requested' do
          rendered.should have_content('You completed pre-registration at 2011-01-01 01:01:01 +0800 and requested the following slots')
        end

        it 'will display the registration details' do
          rendered.should have_content('3 debate teams')
          rendered.should have_content('1 adjudicator')
          rendered.should have_content('1 observer')
        end
      end
    end

    context('when when the system setting "enable_pre_registration" is disabled') do
      before(:each) do
        Setting.stub!(:key).and_return('False')
        render
      end
      context('before the team manager has submitted his registration') do
        it "will tell the team manager that the registration is open" do
          rendered.should have_content('Registration is currently closed')
          rendered.should_not have_content('Registration is open')
        end
        it "will hide the 3 text boxes to fill in the team managers  requests" do
          rendered.should_not have_css('input#registration_debate_teams_requested')
          rendered.should_not have_css('input#registration_adjudicators_requested')
          rendered.should_not have_css('input#registration_observers_requested')
        end
      end

      context('after the team manager has submitted his registration ') do
        let(:user) do
          user = FactoryGirl.create(:user)
          user.confirm!
          registration = FactoryGirl.create(:registration, user: user)
          user.registration = registration
          user
        end

        it 'will not provide the registration form' do
          rendered.should_not have_css('form#new_registration')
        end

        it 'will display the datetime that the registration was requested' do
          rendered.should have_content('You completed pre-registration at 2011-01-01 01:01:01 +0800 and requested the following slots')
        end

        it 'will display the registration details' do
          rendered.should have_content('3 debate teams')
          rendered.should have_content('1 adjudicator')
          rendered.should have_content('1 observer')
        end
      end
    end

  end

  describe "granted slots section" do

    let(:user) do
      user = FactoryGirl.create(:user)
      user.confirm!

      user
    end

    it "is closed by default" do
      render
      rendered.should_not have_content('You have been granted the following slots')
    end

    it "is displayed when the registration has been granted slots closed by default" do
      registration = FactoryGirl.create(:registration, user: user)
      registration.debate_teams_granted = 1
      user.registration = registration
      render
      rendered.should have_content('You have been granted the following slots')
      rendered.should have_content('1 debate team')

    end

  end

  describe "payment section" do

    it "is closed by default" do
      render
      rendered.should_not have_content('Total registration fees due')
      rendered.should_not have_css('form#new_payment')
    end

    it "is displayed when the registration has a fees associated with it" do
      registration = FactoryGirl.create(:registration, user: user, fees:2000)
      payment = FactoryGirl.create(:payment, amount_sent: 1000, amount_received: 999.48, registration: registration)
      #required by _form_payment.html.haml
      @payment = Payment.new
      user.reload
      render
      rendered.should have_content('Total registration fees due RM2,000.00')
      rendered.should have_content('Total confirmed payments RM999.48')
      rendered.should have_content('Balance fees due RM1,000.52')
      rendered.should have_content('Total unconfirmed payments RM0.00')
      rendered.should have_css('form#new_payment')
    end
  end

  # describe "confirmed slot section" do

  #   it "is closed by default" do
  #     render
  #     rendered.should_not have_content('The following slots are confirmed.')
  #   end

  #   it "is displayed when the registration returns true for #confirmed?" do
  #     r = FactoryGirl.create(:registration, user: user, fees:2000)
  #     @payment = Payment.new
  #     r.confirm_slots(1,1,1)
  #     user.reload
  #     render
  #     # rendered.should have_content('Total registration fees due RM2,000.00')
  #     # rendered.should have_content('Total confirmed payments RM999.48')
  #     # rendered.should have_content('Balance fees due RM1,000.52')
  #     # rendered.should have_content('Total unconfirmed payments RM0.00')
  #     # rendered.should have_css('form#new_payment')
  #   end
  # end

end
