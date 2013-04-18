class PaypalRequest

  def initialize options
    @paypal_payment = options[:payment]
    @return_url = options[:return_url]
    @cancel_url = options[:cancel_url]
    #@ipn_notification_url = options[:ipn_notification_url]
    @request = options[:request]
    @logger = options[:logger]
  end

  def recipients
    raise 'Host paypal account setting not set' if @paypal_payment.primary_receiver.nil?
    raise 'Fastrego paypal account setting not set' if @paypal_payment.secondary_receiver.nil?

    [{:email => @paypal_payment.primary_receiver,
      :amount => @paypal_payment.amount_sent,
      :primary => true}, {
        :email => @paypal_payment.secondary_receiver,
        :amount => @paypal_payment.fastrego_fees_portion,
        :primary => false
      }
    ]
  end

  def setup_payment
    setup_options = { ip: @request.remote_ip,
      return_url: @return_url,
      cancel_return_url: @cancel_url,
      currency: @paypal_payment.currency_code,
      locale: 'en', #I18n.locale.to_s.sub(/-/, '_'), #you can put 'en' if you don't know what it means :)
      brand_name: 'FastRego', #The name of the company
      header_image: 'http://www.fastrego.com/assets/fastrego.png',
      allow_guest_checkout: 'true',   #payment with credit card for non PayPal users
      items: [
        {name: "Registration fees for #{@paypal_payment.receiver}",
         description: "Registration fees for #{@paypal_payment.receiver}",
         quantity: "1", amount: @paypal_payment.amount_sent_in_cents }
      ]}

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
    @paypal_payment.update_attributes!(account_number: payer_id)
    response = GATEWAY.purchase(@paypal_payment.amount_sent_in_cents,
                                express_purchase_options)
    @logger.info response
    if response.success?
      @paypal_payment.update_attributes!(amount_received: response.params['gross_amount'].to_f,
                                         status: PaypalPayment::STATUS_COMPLETED)
    end
  end

  private

  def express_purchase_options
  {
    ip: @request.remote_ip,
    token: @paypal_payment.transaction_txnid,
    payer_id: @paypal_payment.account_number,
    currency: @paypal_payment.currency_code
  }
  end

end
