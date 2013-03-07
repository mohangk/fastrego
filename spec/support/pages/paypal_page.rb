class PayPalFlow < GenericPage

  def self.developer_login
    Capybara::visit 'https://developer.paypal.com/'
    Capybara::fill_in 'Email Address', with: ENV['PAYPAL_LOGIN']
    Capybara::fill_in 'Password', with: ENV['PAYPAL_PASSWORD']
    Capybara::click_button 'Log In'
  end

  def on_payment_page?
   has_content? 'Choose a way to pay'
  end

  def has_payment_amount? amount
    has_content? amount
  end

  def complete_payment
    fill_in 'Credit card number', with: '4372896746997231'
    fill_in 'expdate_month', with: '1'
    fill_in 'expdate_year', with: '18'
    fill_in 'cvv2_number', with: '223' 
    fill_in 'ZIP code', with: '35801'
    fill_in 'First name', with: 'Test first name'
    fill_in 'Last name', with: 'Test last name'
    uncheck 'AOHideShowLink'
    fill_in 'Address line 1', with: '123 Stree test'
    select 'AA', from: 'State'
    fill_in 'City', with: 'Test city'
    fill_in 'Mobile', with: '7609871234'
    fill_in 'Phone', with: '7609871234'
    fill_in 'Email', with: 'test@test.com'
    click_button 'Review and Continue'
    click_button 'Continue'
    click_button 'Pay'
    click_button 'Return'
    CompletedPaymentPage.new
  end
end
