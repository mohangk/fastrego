class PaypalRequest

  def initialize paypal_payment
    @paypal_payment = paypal_payment
  end

  def recipients
    raise 'Host paypal account setting not set' if @paypal_payment.primary_receiver.empty?
    raise 'Fastrego paypal account setting not set' if @paypal_payment.secondary_receiver.empty?

    [{:email => @paypal_payment.primary_receiver,
      :amount => @paypal_payment.amount_sent,
      :primary => true}, {
        :email => @paypal_payment.secondary_receiver,
        :amount => @paypal_payment.fastrego_fees_portion,
        :primary => false
      }
    ]
  end

end
