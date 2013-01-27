require 'spec_helper'

describe 'Paypal payments', js: true do

  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:currency_symbol) { FactoryGirl.create(:currency_symbol, tournament: t1) }
  let!(:mmu) { FactoryGirl.create(:institution) }

  before :all do
    FactoryGirl.create :host_paypal_account, tournament: t1
  end

  before :each do
    r = FactoryGirl.create :granted_registration, tournament: t1
    user_login t1, r.team_manager.email, 'password'
    PayPalFlow.developer_login
  end

  it 'allows payment via paypal', js: true do
    tournament = TournamentRegistration.new.tap { |t| t.visit }
    tournament.should_not have_payment
    paypal = tournament.pay_via_paypal
    paypal.should be_on_payment_page
    paypal.should have_payment_amount '90.00'
    tournament = paypal.complete_payment
    tournament.should have_payment
  end

end
