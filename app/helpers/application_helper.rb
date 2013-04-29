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
end
