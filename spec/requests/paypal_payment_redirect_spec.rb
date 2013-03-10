require 'spec_helper'
require Rails.root.join 'lib/stub_gateway'

describe 'Paypal payments redirect', js: true do

  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:currency_symbol) { FactoryGirl.create(:currency_symbol, tournament: t1) }
  let!(:mmu) { FactoryGirl.create(:institution) }

  before :all do
    FactoryGirl.create :host_paypal_account, tournament: t1
  end

  before :each do
    r = FactoryGirl.create :granted_registration, tournament: t1
    user_login t1, r.team_manager.email, 'password'
  end

  it 'polls for the latest payment status, updates it and redirects', js: true do
    tournament = TournamentRegistration.new.tap { |t| t.visit }
    tournament.should_not have_paypal_payment
    completed_payment = tournament.pay_via_paypal true
    completed_payment.status.should == PaypalPayment::STATUS_PENDING
    payment = Payment.find completed_payment.payment_id
    payment.update_attribute(:status, PaypalPayment::STATUS_COMPLETED)
    completed_payment.status? PaypalPayment::STATUS_COMPLETED
    completed_payment.return_to_registration_page
  end

end
