module ApplicationHelper

  PAYPAL_EXPRESS_BUTTON = "https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif"

  def paypal_button pre_registration = false

    if pre_registration
      title = 'Pay pre registration now via PayPal'
      params = { type: 'pre_registration' }
    else
      title = 'Pay now via PayPal'
      params = {}
    end

    link_to image_tag(PAYPAL_EXPRESS_BUTTON), checkout_path(params), title: title, method: :post
  end
end
