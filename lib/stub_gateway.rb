FakeResponse = Struct.new(:payKey, :request, :json)

class ActiveMerchant::Billing::PaypalAdaptivePayment

  def setup_purchase(options)
    @return_url = options[:return_url] || '/FakePayPal'
    fake_response = FakeResponse.new('FakePayKey', {}, {})

    def fake_response.success?
      true
    end

    fake_response
  end

  def redirect_url_for(*args)
    @return_url
  end

end
