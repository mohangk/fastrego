FakeResponse = Struct.new(:payKey, :request, :json, :token)

class ActiveMerchant::Billing::PaypalExpressGateway

  def setup_purchase(amount_in_cents, options)
    @return_url = options[:return_url] || '/FakePayPal'
    fake_response = FakeResponse.new('FakePayKey', {}, {}, 'FakePayKey')

    def fake_response.success?
      true
    end

    fake_response
  end

  def redirect_url_for(*args)
    @return_url
  end

end
