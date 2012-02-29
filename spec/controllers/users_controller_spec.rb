require 'spec_helper'

describe UsersController do

  before(:each) do
    user.confirm!
    sign_in user
  end

  describe "POST registration" do
    let(:user) do
      FactoryGirl.create(:user)
    end
    describe "with valid params" do
      it "creates a new Registration" do
        expect {
          post :registration, { registration: FactoryGirl.attributes_for(:registration) }
        }.to change(Registration, :count).by(1)
      end

      it "assigns a newly created registration as @registration" do
        Timecop.freeze(Time.now) do
          post :registration, { registration: FactoryGirl.attributes_for(:registration) }
          assigns(:registration).should be_a(Registration)
          assigns(:registration).requested_at.should eq(Time.zone.now)
          assigns(:registration).user.should == user
          assigns(:registration).should be_persisted
        end
      end

      it "redirects to the institution list" do
        post :registration, { registration: FactoryGirl.attributes_for(:registration) }
        response.should redirect_to(profile_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved registration as @registration" do
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

  describe "POST payment" do
    let(:user) do
      FactoryGirl.create(:registration).user
    end

    context 'with valid params' do
      it 'creates a new Payment' do
        expect {
          post :payments, { payment: FactoryGirl.attributes_for(:payment) }
        }.to change(Payment, :count).by(1)
      end

      it "assigns a newly created payment as @payment" do
        post :payments, { payment: FactoryGirl.attributes_for(:payment) }
        assigns(:payment).should be_a(Payment)
        assigns(:payment).registration.should == user.registration
        assigns(:payment).should be_persisted
      end

      it "forwards to the profile page on success" do
        post :payments, { payment: FactoryGirl.attributes_for(:payment) }
        response.should redirect_to(profile_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved payment as @payment' do
        Payment.any_instance.stub(:save).and_return(false)
        post :payments, {payment: {}}
        assigns(:payment).should be_a_new(Payment)
      end

      it 'should render profile with the errors' do
        Payment.any_instance.stub(:save).and_return(false)
        post :payments, {payment: {}}
        response.should render_template(:show)
      end
    end
  end


end
