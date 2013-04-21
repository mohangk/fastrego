class CompletedPaymentPage < GenericPage

  def status
    find('.status').text
  end

  def status?(status)
    Capybara.default_wait_time = 10
    page.should have_content status
  end

  def payment_id
    find('.id').text.to_i
  end

  def amount
    find('.amount').text
  end

  def redirected?
    page.should have_content 'Requested slots'
  end

  def return_to_registration_page
    Capybara.ignore_hidden_elements = true
    page.should have_content 'Return to registration page'
    click_link 'Return to registration page'
  end

end

