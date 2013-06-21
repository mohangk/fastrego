class PaypalRequest

  def initialize options
    @paypal_payment = options[:payment]
    @logger = options[:logger]
    @request = options[:request]
    @gateway =  ActiveMerchant::Billing::PaypalExpressGateway.new(
      login:     options[:paypal_login],
      password:  options[:paypal_password],
      signature: options[:paypal_signature])
  end

  def setup_payment return_url, cancel_url
    setup_options = { ip: @request.remote_ip,
      order_id: @paypal_payment.id,
      no_shipping: true,
      return_url: return_url,
      cancel_return_url: cancel_url,
      currency: @paypal_payment.conversion_currency,
      locale: 'en',
      brand_name: 'FastRego',
      header_image: 'http://www.fastrego.com/assets/fastrego.png',
      allow_guest_checkout: 'true',
      items: purchase_items }

    response = @gateway.setup_purchase(to_cents(@paypal_payment.amount_sent_as_convertible_money.conversion_amount), setup_options)

    @logger.info "PAYPAL Setup purchase request'#{response.inspect}'"
    @logger.info "PAYPAL Setup purchase response'#{response.inspect}'"

    if response.success?
      @paypal_payment.update_pay_key(response.token)
      @gateway.redirect_url_for(response.token)
    else
      raise 'Setup purchase response from Paypal failed'
    end

  end

  def complete_payment token, payer_id
    payment_details = @gateway.details_for token
    @logger.info payment_details
    @paypal_payment.update_attributes!(account_number: payer_id)
    response = @gateway.purchase(to_cents(@paypal_payment.amount_sent_as_convertible_money.conversion_amount),
                                express_purchase_options)
    @logger.info response
    if response.success?
      @paypal_payment.conversion_amount_received = response.params['gross_amount'].to_d
      @paypal_payment.status = PaypalPayment::STATUS_COMPLETED
      @paypal_payment.save
    end
  end

  def express_purchase_options
    {
      ip: @request.remote_ip,
      token: @paypal_payment.transaction_txnid,
      payer_id: @paypal_payment.account_number,
      currency: @paypal_payment.conversion_currency
    }
  end

  def purchase_items
    [
      {
        name: @paypal_payment.details,
        quantity: 1,
        amount: to_cents(@paypal_payment.registration_fees_as_convertible_money.conversion_amount)
      },
      {
        name: 'Paypal transaction fees',
        quantity: 1,
        amount: to_cents(@paypal_payment.fastrego_fees_as_convertible_money.conversion_amount)
      }
    ]
  end

  private

  def to_cents(amount)
    amount * 100
  end



end
