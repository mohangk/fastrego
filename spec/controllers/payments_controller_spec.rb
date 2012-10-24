require 'spec_helper'


describe PaymentsController do 

  let(:registration) { FactoryGirl.create(:granted_registration) }
  let(:user) { registration.team_manager }

  before(:each) do
    user.confirm!
    sign_in user
    controller.stub(:current_registration).and_return(registration)
    controller.stub(:current_tournament).and_return(registration.tournament)
  end


  context 'when not logged in' do
    it 'requires authentication' do
      sign_out user
      post :create, registration: {}
      response.status.should == 302
    end
  end

  pending 'when not assigned as a team manager yet/ registration not persisted'
  describe "POST payment" do


    context 'with valid params' do
      it 'creates a new Payment' do
        expect {
          post :create, { payment: FactoryGirl.attributes_for(:payment) }
        }.to change(Payment, :count).by(1)
      end

      it "assigns a newly created payment as @payment" do
        post :create, { payment: FactoryGirl.attributes_for(:payment) }
        assigns(:payment).should be_a(Payment)
        assigns(:payment).registration.team_manager.should == user
        assigns(:payment).should be_persisted
      end

      it "forwards to the profile page on success" do
        post :create, { payment: FactoryGirl.attributes_for(:payment) }
        response.should redirect_to(profile_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved payment as @payment' do
        Payment.any_instance.stub(:save).and_return(false)
        post :create, {payment: {}}
        assigns(:payment).should be_a_new(Payment)
      end

      it 'should render profile with the errors' do
        Payment.any_instance.stub(:save).and_return(false)
        post :create, {payment: {}}
        response.should render_template(:show)
      end
    end
  end
  describe "DELETE payment" do
    let!(:payment) { FactoryGirl.create :payment, registration: registration }

    it 'deletes the payment' do
      expect { 
        delete :destroy, { id: payment.id }
      }.to change(Payment, :count).by(-1)
    end

    it 'ensures that the payment belongs to the current_user' do
      user2 = FactoryGirl.create :user
      sign_in user2
      expect { 
        delete :destroy, { id: payment.id }
      }.to change(Payment, :count).by(0)
    end 

    it 'ensures that the payment is not confirmed yet' do
      Payment.any_instance.stub(:confirmed?).and_return(true)
      expect { 
        delete :destroy, { id: payment.id }
      }.to change(Payment, :count).by(0)
    end

    it 'renders the profile page' do
      delete :destroy, { id: payment.id }
      response.should redirect_to profile_url
    end

  end

end
