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
    @return_url+'?token=fakeToken&PayerID=fakePayerID'
  end

  def purchase(amount_sent_in_cents, express_purchase_options)
    OpenStruct.new(success?: true, params: {'gross_amount' => amount_sent_in_cents/100 })
  end

  def details_for(*args)
  end
end
