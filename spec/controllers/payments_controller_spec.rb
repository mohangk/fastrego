require 'spec_helper'

Notification = ActiveMerchant::Billing::Integrations::PaypalAdaptivePayment::Notification

def GATEWAY.setup_purchase(*args)
  { 'payKey' => 'FakePayKey' }
end

def GATEWAY.redirect_url_for(*args)
  '/FakePayPal'
end

describe PaymentsController do

  let(:registration) { FactoryGirl.create(:granted_registration) }
  let(:user) { registration.team_manager }

  before(:each) do
    FactoryGirl.create :host_paypal_account, tournament: registration.tournament
    user.confirm!
    sign_in user
    controller.stub(:current_registration).and_return(registration)
    controller.stub(:current_tournament).and_return(registration.tournament)

    Notification.any_instance.stub(acknowledge: true,
                                   complete?: true)
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
          post :create, { payment: FactoryGirl.attributes_for(:manual_payment) }
        }.to change(Payment, :count).by(1)
      end

      it "assigns a newly created payment as @payment" do
        post :create, { payment: FactoryGirl.attributes_for(:manual_payment) }
        assigns(:payment).should be_a(ManualPayment)
        assigns(:payment).registration.team_manager.should == user
        assigns(:payment).should be_persisted
      end

      it "forwards to the profile page on success" do
        post :create, { payment: FactoryGirl.attributes_for(:manual_payment) }
        response.should redirect_to(profile_path)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved payment as @payment' do
        ManualPayment.any_instance.stub(:save).and_return(false)
        post :create, {payment: {}}
        assigns(:payment).should be_a_new(ManualPayment)
      end

      it 'should render profile with the errors' do
        ManualPayment.any_instance.stub(:save).and_return(false)
        post :create, {payment: {}}
        response.should render_template(:show)
      end
    end
  end

  describe "DELETE payment" do
    let!(:payment) { FactoryGirl.create :manual_payment, registration: registration }

    it 'deletes the payment' do
      expect {
        delete :destroy, { id: payment.id }
      }.to change(ManualPayment, :count).by(-1)
    end

    it 'ensures that the payment belongs to the current_user' do
      user2 = FactoryGirl.create :user
      sign_in user2
      expect {
        delete :destroy, { id: payment.id }
      }.to change(ManualPayment, :count).by(0)
    end

    it 'ensures that the payment is not confirmed yet' do
      ManualPayment.any_instance.stub(:confirmed?).and_return(true)
      expect {
        delete :destroy, { id: payment.id }
      }.to change(ManualPayment, :count).by(0)
    end

    it 'renders the profile page' do
      delete :destroy, { id: payment.id }
      response.should redirect_to profile_url
    end

  end

  describe "POST checkout" do

    subject(:checkout) { post :checkout }

    it 'assigns a newly created payment as @paypal_payment' do
      checkout
      assigns(:paypal_payment).should be_a(PaypalPayment)
      assigns(:paypal_payment).registration.team_manager.should == user
      assigns(:paypal_payment).amount_sent.should == registration.balance_fees
      assigns(:paypal_payment).should be_persisted
    end

    context 'with valid params' do
      it 'creates a new Payment' do
        expect {
          checkout
        }.to change(PaypalPayment, :count).by(1)
      end

      it 'redirects to Paypal' do
        checkout
        response.should redirect_to('/FakePayPal')
      end
    end

    context 'when there are validation errors' do
      before do
        fake_paypal_payment = double(:paypal_payment, save: false, errors: double(full_messages: ["Error Message"],any?: true)).as_null_object
        PaypalPayment.stub(:new).and_return(fake_paypal_payment)
      end

      it 'should render tournament registration page' do
        checkout
        response.should render_template(:show)
      end

      it "should display validation errors" do
        checkout
        response.body.should have_content("Failure when trying to submit to PayPal")
      end
    end

    context 'when there are excpetions' do
      before do
        GATEWAY.stub(:setup_purchase).and_raise(Exception.new)
      end

      it 'should render tournament registration page' do
        checkout
        response.should render_template(:show)
      end

      it "should display validation errors" do
        checkout
        response.body.should have_content("Failure when trying to submit to PayPal")
      end
    end

  end

  describe "POST ipn" do
    let(:params) {
      {
        "transaction"=>
        {"0"=>
         {".is_primary_receiver"=>"true",
          ".id_for_sender_txn"=>"9K096230EL9214721",
          ".receiver"=>"fastre_1356344930_biz@gmail.com",
          ".amount"=>"USD 1000.00",
          ".status"=>"Completed",
          ".id"=>"06L90310UW5273008",
          ".status_for_sender_txn"=>"Completed",
          ".paymentType"=>"SERVICE",
          ".pending_reason"=>"NONE"},
          "1"=>
         {".paymentType"=>"SERVICE",
          ".id_for_sender_txn"=>"21X87400MR783724Y",
          ".is_primary_receiver"=>"false",
          ".status_for_sender_txn"=>"Completed",
          ".receiver"=>"mohang_1356050668_biz@gmail.com",
          ".amount"=>"USD 900.00",
          ".pending_reason"=>"NONE",
          ".id"=>"8LK3354461194463S", ".status"=>"Completed"}
        },
        "log_default_shipping_address_in_transaction"=>"false",
        "action_type"=>"PAY",
        "ipn_notification_url"=>"http://staging-mt-fastrego.herokuapp.com/ipn",
        "charset"=>"windows-1252", "transaction_type"=>"Adaptive Payment PAY",
        "notify_version"=>"UNVERSIONED",
        "cancel_url"=>"http://staging-mt-fastrego.herokuapp.com/canceled",
        "verify_sign"=>"AUv8k1qXzdVB6.NDG8oijgOskCK2A2PY9giokojAf13jj8IpDQN1rsgY",
        "sender_email"=>"buyer_1356051155_per@gmail.com",
        "fees_payer"=>"EACHRECEIVER",
        "return_url"=>"http://staging-mt-fastrego.herokuapp.com/completed",
        "reverse_all_parallel_payments_on_error"=>"false",
        "pay_key"=>"AP-6HN366870A409841A",
        "status"=>"COMPLETED",
        "test_ipn"=>"1",
        "payment_request_date"=>"Sat Jan 05 00:02:23 PST 2013"}
    }

    subject(:ipn) { post :ipn, params }

    before do
      sign_out user
    end

    it 'does not require authentication' do
      ipn
      response.status.should_not == 302
    end

    it 'logs the missing payment if the payment cannot be found' do
      Rails.logger.should_receive :error
      ipn
    end

    context 'when the payment is found' do
      let!(:payment) { FactoryGirl.create :paypal_payment, 
                       transaction_txnid: params['pay_key'], 
                       amount_sent: params['transaction']['0']['.amount'].split[1].to_i,
                       registration: registration }

      it 'sets it as paid' do
        ipn
        payment.reload
        payment.status.should == 'Success' 
      end

    end

    context 'handles forged requests' do
      before :each do
        Notification.any_instance.stubs(amount: 100.00,
                                        acknowledge: false,
                                        complete?: true)
      end

      pending 'log the errors'
      pending 'make sure the order is not confirmed'

    end

  end
end
