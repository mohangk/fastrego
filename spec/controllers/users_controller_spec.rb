require 'spec_helper'

describe UsersController do

  let(:user) do
    user = Factory(:user)
  end

  before(:each) do
    user.confirm!
    sign_in user
  end

  def valid_attributes
    {
        debate_teams_requested: 1,
        adjudicators_requested: 1,
        observers_requested: 1
    }
  end



  describe "POST registration" do
    describe "with valid params" do
      it "creates a new Registration" do
        sign_in user
        expect {
          post :registration, {:registration => valid_attributes}
        }.to change(Registration, :count).by(1)
      end

      it "assigns a newly created registration as @registration" do
        Timecop.freeze(Time.now)
        post :registration, {:registration => valid_attributes}
        assigns(:registration).should be_a(Registration)
        assigns(:registration).requested_at.should eq(Time.zone.now)
        assigns(:registration).user.should == user
        assigns(:registration).should be_persisted
        Timecop.return
      end

      it "redirects to the institution list" do
        post :registration, {:registration => valid_attributes}
        response.should redirect_to(profile_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved institution as @institution" do
        # Trigger the behavior that occurs when invalid params are submitted
        Registration.any_instance.stub(:save).and_return(false)
        post :registration, {:registration => {}}
        assigns(:registration).should be_a_new(Registration)
      end

      it "re-renders the 'show' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Registration.any_instance.stub(:save).and_return(false)
        post :registration, {:registration => {}}
        response.should render_template("show")
      end
    end
  end


end
