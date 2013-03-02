FakeResponse = Struct.new(:payKey, :request, :json)

def GATEWAY.setup_purchase(options)
  @return_url = options[:return_url]
  fake_response = FakeResponse.new('FakePayKey', {}, {})

  def fake_response.success?
    true
  end

  fake_response
end

def GATEWAY.redirect_url_for(*args)
  @return_url
end
