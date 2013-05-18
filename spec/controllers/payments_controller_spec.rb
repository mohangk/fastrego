require 'spec_helper'
require Rails.root.join 'lib/stub_gateway'

Notification = ActiveMerchant::Billing::Integrations::PaypalAdaptivePayment::Notification

describe PaymentsController do

  let(:expected_paypal_request_params) do
    { payment: paypal_payment,
                      logger: controller.logger,
                      request: request,
                      paypal_login: 'fake_paypal_login',
                      paypal_password: 'fake_paypal_password',
                      paypal_signature: 'fake_paypal_signature'
    }
  end

  let(:registration) { FactoryGirl.create(:granted_registration) }
  let(:user) { registration.team_manager }

  before(:each) do
    user.confirm!
    sign_in user
    controller.stub(:current_registration).and_return(registration)
    t = registration.tournament
    t.stub(:paypal_login).and_return('fake_paypal_login')
    t.stub(:paypal_password).and_return('fake_paypal_password')
    t.stub(:paypal_signature).and_return('fake_paypal_signature')
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

  describe 'GET /payment/:id' do

    let(:paypal_payment) { FactoryGirl.create :paypal_payment, registration: registration }

    subject(:show_payment) {
      get :show, id: paypal_payment.id, format: :json
    }

    it 'assigns the right payment' do
      sign_in user
      show_payment
      assigns(:paypal_payment).id.should == paypal_payment.id
      assigns(:paypal_payment).should be_a(PaypalPayment)
    end

    it 'responds with JSON' do
      show_payment
      response.status.should == 200
      response.headers['Content-Type'].should match /application\/json/
    end

    context 'when someone else tries to access the payment' do

      before :each do
        user2 = FactoryGirl.create :user
        sign_in user2
        show_payment
      end

      it "redirects back to profile" do
        response.should redirect_to profile_path
      end

    end

  end

  describe 'POST payment' do

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

  describe 'POST checkout' do

    subject(:checkout) { post :checkout }

    before do
      PaypalRequest.stub(:new).and_return(paypal_request)
    end

    let(:paypal_request) { double('paypal request', setup_payment: '/FakePaypalUrl') }

    describe 'PaypalRequest integration' do
      before do

        PaypalPayment.stub(:generate).and_return paypal_payment

        PaypalRequest.should_receive(:new)
          .with(expected_paypal_request_params)
          .and_return(paypal_request)

        paypal_request.should_receive(:setup_payment).with(return_url, cancel_url).and_return '/FakePaypalUrl'

      end

      let(:return_url) { completed_payment_url(id: paypal_payment.id) }
      let(:cancel_url) { canceled_payment_url(id: paypal_payment.id) }
      let(:request) { controller.request }
      let(:paypal_payment) { double('paypal payment', id: 123) }

      it 'sets up PaypalRequest' do
        checkout
      end
    end

    it 'generates a PaypalPayment' do
      PaypalRequest.any_instance.stub(:setup_payment).and_return '/FakeyPayPal'
      PaypalPayment.should_receive(:generate).with(registration, false).and_return(double(:paypal_payment, id: 999))
      checkout
    end

    it 'creates a new Payment' do
      expect {
        checkout
      }.to change(PaypalPayment, :count).by(1)
    end

    it 'redirects to Paypal' do
      checkout
      response.should redirect_to('/FakePaypalUrl')
    end

    context 'when type is pre_registration' do
      before do
        PaypalRequest.any_instance.stub(:setup_payment).and_return '/FakeyPayPal'
      end

      it 'generates a pre_registration PaypalPayment' do
        PaypalPayment.should_receive(:generate).with(registration, true).and_return(double(:paypal_payment, id: 999))
        post :checkout, type: 'pre_registration'
      end
    end

    context 'when there are exceptions' do
      before do
        paypal_request.stub(:setup_payment).and_raise(Exception.new)
      end

      it 'leaves the payment status as draft' do
        checkout
        assigns(:paypal_payment).status.should == PaypalPayment::STATUS_DRAFT
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

  describe "GET completed" do
    let(:paypal_payment) { FactoryGirl.create :paypal_payment, registration: registration }

    let(:completed) { get :completed, { id: paypal_payment.id }   }

    it 'initializes the right payment' do
      completed
      assigns(:paypal_payment).should be_a(PaypalPayment)
      assigns(:paypal_payment).id.should == paypal_payment.id
    end

    it 'should render tournament registration page' do
      completed
      response.should render_template(:completed)
    end

    context 'when it is handling a PaypalExpress request' do
      let(:completed) { get :completed, { id: paypal_payment.id, token: 'FakePayKey', PayerID: 'FakePayerID' }   }

      let(:paypal_request) { double('paypal request') }

      it 'initializes a PaypalRequest and completes the payment' do

        PaypalRequest.should_receive(:new)
          .with(expected_paypal_request_params)
          .and_return(paypal_request)

        paypal_request.should_receive(:complete_payment).with('FakePayKey', 'FakePayerID')
        completed
      end

    end

    context 'when someone tries to access payments not owned by them' do

      before :each do
        user2 = FactoryGirl.create :user
        sign_in user2
        completed
      end

      it "redirects back to profile" do
        response.should redirect_to profile_path
      end
    end
  end

  describe "GET canceled" do
    let(:paypal_payment) { FactoryGirl.create :paypal_payment, registration: registration }

    subject(:canceled) { get :canceled, { id: paypal_payment.id }   }

    it 'initializes the right payment' do
      canceled
      assigns(:paypal_payment).should be_a(PaypalPayment)
      assigns(:paypal_payment).id.should == paypal_payment.id
    end

    it 'sets the payment status to cancel' do
      canceled
      assigns(:paypal_payment).status.should == PaypalPayment::STATUS_CANCELED
    end

    it 'should render tournament registration page' do
      canceled
      response.should render_template(:canceled)
    end

    context 'when someone tries to access payments not owned by them' do

      before :each do
        user2 = FactoryGirl.create :user
        sign_in user2
        canceled
      end

      it "doesn't allow you to edit other folks payments" do
        assigns(:paypal_payment).status.should == PaypalPayment::STATUS_DRAFT
      end

      it "redirects back to profile" do
        response.should redirect_to profile_path
      end
    end

  end

  describe "POST ipn" do
    let(:raw_request) {
      "transaction%5B0%5D.is_primary_receiver=true&\
transaction%5B0%5D.id_for_sender_txn=8PY816957G648382H&\
log_default_shipping_address_in_transaction=false&\
transaction%5B0%5D.receiver=fastre_1356344930_biz%40gmail.com&\
action_type=PAY&ipn_notification_url=http%3A//staging-mt-fastrego.herokuapp.com/ipn&\
transaction%5B1%5D.paymentType=SERVICE&\
transaction%5B0%5D.amount=USD+50.00&\
charset=windows-1252&transaction_type=Adaptive+Payment+PAY&\
transaction%5B1%5D.id_for_sender_txn=76E764642W014120T&\
transaction%5B1%5D.is_primary_receiver=false&\
transaction%5B0%5D.status=Completed&\
notify_version=UNVERSIONED&\
transaction%5B0%5D.id=9GL074773F315032R&\
cancel_url=http%3A//staging-mt-fastrego.herokuapp.com/canceled&\
transaction%5B1%5D.status_for_sender_txn=Completed&\
transaction%5B1%5D.receiver=mohang_1356050668_biz%40gmail.com&\
verify_sign=Ayoqld3fWVmmp5xMCzJQ60DBUtsYAmdKdz0xbQ7-WEELGYIYNfQA-qu1&\
sender_email=buyer2_1356051252_per%40gmail.com&\
fees_payer=EACHRECEIVER&\
transaction%5B0%5D.status_for_sender_txn=Completed&\
return_url=http%3A//staging-mt-fastrego.herokuapp.com/&\
transaction%5B0%5D.paymentType=SERVICE&\
transaction%5B1%5D.amount=USD+47.50&\
reverse_all_parallel_payments_on_error=false&\
transaction%5B1%5D.pending_reason=NONE&\
pay_key=AP-6AB52111TJ2109115&\
transaction%5B1%5D.id=02T89064XT796082E&\
transaction%5B0%5D.pending_reason=NONE&\
status=COMPLETED&transaction%5B1%5D.status=Completed&test_ipn=1&\
payment_request_date=Fri+Jan+18+20%3A01%3A29+PST+2013"
    }

    subject(:ipn) { @request.env['RAW_POST_DATA'] = raw_request; post :ipn, { }, 'CONTENT_TYPE' => 'application/octet-stream'; @request.env.delete('RAW_POST_DATA') }

    let(:notification_params) { Notification.new(raw_request).params }

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
                       transaction_txnid: notification_params['pay_key'],
                       amount_sent: notification_params['transaction[0].amount'].split[1].to_i,
                       registration: registration }

      it 'sets it as paid' do
        ipn
        payment.reload
        payment.status.should == PaypalPayment::STATUS_COMPLETED
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
