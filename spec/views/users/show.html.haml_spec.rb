require 'spec_helper'

describe "users/show.html.haml" do
  before(:each) do
    sign_in Factory(:user)
    @registration = Registration.new
  end

  it "renders the team managers details" do
    render
    rendered.should match(/Suthen Thomas/)
    rendered.should match(/suthen.thomas@gmail.com/)
    rendered.should match(/123123123123/)
    rendered.should match(/Multimedia University/)
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

      it "will not  tell the team manager that registration is closed" do
        rendered.should_not have_content('Registration is currently closed.')
      end
      it "will provide 3 text boxes to fill in the team managers  requests" do
        rendered.should have_css('input#registration_debate_team_requested')
        rendered.should have_css('input#registration_adjudicators_requested')
        rendered.should have_css('input#registration_observers_requested')
      end
    end

  end


end
