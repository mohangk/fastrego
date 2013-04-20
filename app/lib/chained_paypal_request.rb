class ChainedPaypalRequest

  def initialize options
    @paypal_payment = options[:payment]
    @return_url = options[:return_url]
    @cancel_url = options[:cancel_url]
    @ipn_notification_url = options[:ipn_notification_url]
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
    response = GATEWAY.setup_purchase(
      :currency_code =>        @paypal_payment.currency_code,
      :fees_payer =>           'SECONDARYONLY',
      :return_url =>           @return_url,
      :cancel_url =>           @cancel_url,
      :ipn_notification_url => @ipn_notification_url,
      :receiver_list =>        recipients)

    @logger.info "PAYPAL Setup purchase request'#{response.inspect}'"
    @logger.info "PAYPAL Setup purchase response'#{response.inspect}'"

    if response.success?
      @paypal_payment.update_pay_key(response["payKey"])
      GATEWAY.redirect_url_for(response["payKey"])
    else
      raise 'Setup purchase response from Paypal failed'
    end
  end

end
