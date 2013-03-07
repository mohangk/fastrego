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

  def redirected?
    page.should have_content 'Requested slots'
  end


end

