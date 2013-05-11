require 'spec_helper'

describe 'PaypalRequest' do

  let(:return_url) { double('return_url') }
  let(:cancel_url) { double('cancel_url') }
  let(:logger) { double(:logger, info: nil) }
  let(:request) { double(:request, remote_ip: '1.1.1.1')}

  let (:payment) do
    paypal_payment = FactoryGirl.create(:paypal_payment)
    paypal_payment.stub( primary_receiver: 'fakehost@gmail.com',
    secondary_receiver: 'fastrego@gmail.com',
    amount_sent: 10.00,
    fastrego_fees_portion: 1.00)

    paypal_payment
  end

  let(:payment_request) {
    PaypalRequest.new(payment: payment,
       logger: logger,
       request: request)
  }

  describe 'initialization' do
    it { payment_request.instance_variable_get(:@paypal_payment).should == payment }
    it { payment_request.instance_variable_get(:@logger).should == logger }
    it { payment_request.instance_variable_get(:@request).should == request }

  end

  describe "setup_payment" do
    before do
      GATEWAY.stub(:setup_purchase).and_return setup_purchase_response
      GATEWAY.stub(:redirect_url_for)
      payment_request.stub(:purchase_items).and_return items

      setup_options = {
                    ip: request.remote_ip,
                    order_id: payment.id,
                    return_url: return_url,
                    no_shipping: true,
                    cancel_return_url: cancel_url,
                    currency: payment.currency_code,
                    locale: 'en',
                    brand_name: 'FastRego',
                    header_image: 'http://www.fastrego.com/assets/fastrego.png',
                    allow_guest_checkout: 'true',
                    items:items
                    }
      GATEWAY.should_receive(:setup_purchase).with(payment.amount_sent_in_cents, setup_options)
    end

    let(:setup_purchase_response) { double(:response, 'success?' => true, 'token' => 'FakePayKey') }
    let(:items) { double(:items) }

    it 'passes the right params' do
      payment_request.setup_payment(return_url, cancel_url)
    end

    it 'returns the redirection URL' do
      GATEWAY.should_receive(:redirect_url_for).with 'FakePayKey'
      payment_request.setup_payment(return_url, cancel_url)
    end
  end


  describe '#purchase_items' do
    it 'returns two row of items' do

      payment_request.purchase_items.size.should == 2

    end
  end

end
