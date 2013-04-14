require 'spec_helper'

shared_examples 'Paypal recipients hash' do

  it { should be_a(Hash) }
  it {subject.keys.should include(:email, :amount, :primary)}
  it {subject[:email].should == email}
  it {subject[:amount].should == amount}
  it {subject[:primary].should == primary}

end

describe 'ChainedPaypalRequest' do

  let(:return_url) { double('return_url') }
  let(:cancel_url) { double('cancel_url') }
  let(:ipn_notification_url) { double('ipn_notification_url') }
  let (:payment) do
    paypal_payment = FactoryGirl.create(:paypal_payment)
    paypal_payment.stub( primary_receiver: 'fakehost@gmail.com',
    secondary_receiver: 'fastrego@gmail.com',
    amount_sent: 10.00,
    fastrego_fees_portion: 1.00)

    paypal_payment
  end

  let(:payment_request) {
      ChainedPaypalRequest.new(payment: payment,
       return_url: return_url,
       cancel_url: cancel_url,
       ipn_notification_url: ipn_notification_url)
  }


  describe "#setup_chained_payment" do
    before do
      payment_request.stub(:recipients).and_return(recipients)
    end
    let(:recipients) { double('recipients') }

    it 'passes the right params' do
      setup_options = { currency_code: payment.currency_code,
                    fees_payer: 'SECONDARYONLY',
                    return_url: return_url,
                    cancel_url: cancel_url,
                    ipn_notification_url: ipn_notification_url,
                    receiver_list: recipients }

      GATEWAY.should_receive(:setup_purchase).with setup_options
      payment_request.setup_payment
    end
  end

  describe "#paypal_recipients" do

    subject(:recipients) { payment_request.recipients }

    its(:count) { should == 2}

    it { should be_a(Array) }

    context 'the first hash' do
      subject { payment_request.recipients.first }
      let(:email) { payment.primary_receiver }
      let(:amount) { payment.amount_sent }
      let(:primary) { true }
      it_behaves_like 'Paypal recipients hash'
    end

    context 'the second hash' do
      subject { payment_request.recipients.last }
      let(:email) { payment.secondary_receiver }
      let(:amount) { payment.fastrego_fees_portion }
      let(:primary) { false }
      it_behaves_like 'Paypal recipients hash'
    end

    context 'when email is not provided' do

      let (:payment) { double('payment',
                              primary_receiver: nil,
                              secondary_receiver: 'fastrego@gmail.com',
                              amount_sent: 10.00,
                              fastrego_fees_portion: 1.00) }
      it 'should raise an error' do
        expect {payment_request.recipients}.to raise_error
      end
    end

  end
end
