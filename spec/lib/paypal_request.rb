require 'spec_helper'

shared_examples 'Paypal recipients hash' do

  it { should be_a(Hash) }
  it {subject.keys.should include(:email, :amount, :primary)}
  it {subject[:email].should == email}
  it {subject[:amount].should == amount}
  it {subject[:primary].should == primary}

end

MockPaypalPayment = Struct.new :primary_receiver,
                    :secondary_receiver,
                    :amount_sent,
                    :fastrego_fees_portion


describe 'PaypalRequest' do

  let (:paypal_payment) { MockPaypalPayment.new(
                              'fakehost@gmail.com',
                              'fastrego@gmail.com',
                              10.00,
                              1.00) }

  describe "#paypal_recipients" do

    subject(:recipients) { PaypalRequest.new(paypal_payment).recipients }

    its(:count) { should == 2}

    it { should be_a(Array) }

    context 'the first hash' do
      subject { PaypalRequest.new(paypal_payment).recipients.first }
      let(:email) { paypal_payment.primary_receiver }
      let(:amount) { paypal_payment.amount_sent }
      let(:primary) { true }
      it_behaves_like 'Paypal recipients hash'
    end

    context 'the second hash' do
      subject { PaypalRequest.new(paypal_payment).recipients.last }
      let(:email) { paypal_payment.secondary_receiver }
      let(:amount) { paypal_payment.fastrego_fees_portion }
      let(:primary) { false }
      it_behaves_like 'Paypal recipients hash'
    end

    context 'when email is not provided' do

      let (:paypal_payment) { MockPaypalPayment.new(
                              nil,
                              'fastrego@gmail.com',
                              10.00,
                              1.00) }
      it 'should raise an error' do
        expect {PaypalRequest.new(paypal_payment).recipients}.to raise_error
      end
    end

  end
end
