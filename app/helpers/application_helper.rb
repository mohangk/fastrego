module ApplicationHelper

  PAYPAL_EXPRESS_BUTTON = "https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif"

  def paypal_button pre_registration = false

    if pre_registration
      title = 'Pay pre registration now via PayPal'
      link_params = { type: 'pre_registration' }
      modal = 'preRegistrationModal'
    else
      title = 'Pay now via PayPal'
      link_params = {}
      modal = 'registrationModal'
    end

    link_to image_tag(PAYPAL_EXPRESS_BUTTON),
      paypal_payment_notice_path(link_params),
      'data-target'=>"##{modal}",
      title: title,
      'data-toggle' => 'modal'
  end

  def tournament_currency amount
    amount_string = number_to_currency amount, unit: current_tournament.currency_symbol

    if current_tournament.paypal_currency_conversion?
      amount_string += paypal_currency amount
    end
    amount_string
  end

  def paypal_currency amount
    " (#{number_to_currency paypal_currency_conversion(amount), unit: current_tournament.paypal_currency})"
  end

  def paypal_currency_conversion amount
    amount * current_tournament.paypal_conversion_rate
  end
end
