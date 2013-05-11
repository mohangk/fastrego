class PaypalRequest

  def initialize options
    @paypal_payment = options[:payment]
    @logger = options[:logger]
    @request = options[:request]
  end

  def setup_payment return_url, cancel_url
    setup_options = { ip: @request.remote_ip,
      order_id: @paypal_payment.id,
      no_shipping: true,
      return_url: return_url,
      cancel_return_url: cancel_url,
      currency: @paypal_payment.currency_code,
      locale: 'en',
      brand_name: 'FastRego',
      header_image: 'http://www.fastrego.com/assets/fastrego.png',
      allow_guest_checkout: 'true',
      items: purchase_items }

    response = GATEWAY.setup_purchase(@paypal_payment.amount_sent_in_cents, setup_options)

    @logger.info "PAYPAL Setup purchase request'#{response.inspect}'"
    @logger.info "PAYPAL Setup purchase response'#{response.inspect}'"

    if response.success?
      @paypal_payment.update_pay_key(response.token)
      GATEWAY.redirect_url_for(response.token)
    else
      raise 'Setup purchase response from Paypal failed'
    end

  end

  def complete_payment token, payer_id
    payment_details = GATEWAY.details_for token
    @logger.info payment_details
    @paypal_payment.update_attributes!(account_number: payer_id)
    response = GATEWAY.purchase(@paypal_payment.amount_sent_in_cents,
                                express_purchase_options)
    @logger.info response
    if response.success?
      @paypal_payment.update_attributes!(amount_received: response.params['gross_amount'].to_f,
                                         status: PaypalPayment::STATUS_COMPLETED)
    end
  end

  def express_purchase_options
    {
      ip: @request.remote_ip,
      token: @paypal_payment.transaction_txnid,
      payer_id: @paypal_payment.account_number,
      currency: @paypal_payment.currency_code
    }
  end

  def purchase_items
    [
      {
        name: @paypal_payment.details,
        quantity: 1,
        amount: @paypal_payment.registration_fees_in_cents
      },
      {
        name: 'Paypal transaction fees',
        quantity: 1,
        amount: @paypal_payment.fastrego_fees_in_cents
      }
    ]
  end

end
