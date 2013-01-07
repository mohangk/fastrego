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

    visit 'https://developer.paypal.com/'
    fill_in 'Email Address', with: ENV['PAYPAL_LOGIN']
    fill_in 'Password', with: ENV['PAYPAL_PASSWORD']
    click_button 'Log In'
  end

  it 'allows payment via paypal', js: true do
    tournament = TournamentRegistration.new.tap { |t| t.visit }
    tournament.pay_via_paypal
    page.should have_content 'Choose a way to pay'
    page.should have_content '90.00'
  end

end
