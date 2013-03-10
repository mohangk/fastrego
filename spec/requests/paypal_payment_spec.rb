require 'spec_helper'

describe 'Paypal payments integration', js: true do

  before :each do
    t1 = FactoryGirl.create(:t1_tournament)
    FactoryGirl.create(:currency_symbol, tournament: t1)
    FactoryGirl.create(:institution)
    FactoryGirl.create :host_paypal_account, tournament: t1
    r = FactoryGirl.create :granted_registration, tournament: t1
    user_login t1, r.team_manager.email, 'password'
    PayPalFlow.developer_login
  end

  it 'allows payment via paypal', js: true do
    tournament = TournamentRegistration.new.tap { |t| t.visit }
    tournament.should_not have_paypal_payment
    paypal = tournament.pay_via_paypal
    paypal.should be_on_payment_page
    paypal.should have_payment_amount '90.00'
    completed_page = paypal.complete_payment
    #force an update - IPN wont reach local server
    payment = Payment.find completed_page.payment_id
    payment.update_attributes status: PaypalPayment::STATUS_COMPLETED
    completed_page.status? 'Completed'
    completed_page.return_to_registration_page
    tournament = TournamentRegistration.new
    tournament.should have_paypal_payment
  end

  it 'handles cancelation', js: true do
    tournament = TournamentRegistration.new.tap { |t| t.visit }
    tournament.should_not have_paypal_payment
    paypal = tournament.pay_via_paypal
    paypal.should be_on_payment_page
    canceled_page = paypal.cancel_payment
    canceled_page.status? 'Canceled'
    canceled_page.return_to_registration_page
    tournament = TournamentRegistration.new
    tournament.should have_paypal_payment
  end

end
