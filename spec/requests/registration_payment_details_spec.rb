require 'spec_helper'
require Rails.root.join 'lib/stub_gateway'

describe 'Registration payment table spec' do

  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:currency_symbol) { FactoryGirl.create(:currency_symbol, tournament: t1) }
  let!(:mmu) { FactoryGirl.create(:institution) }
  let(:registration) { FactoryGirl.create :granted_registration, tournament: t1 }

  before :each do
    user_login t1, registration.team_manager.email, 'password'
  end


  context 'when there is a pre-registration fees set' do
    before do
      FactoryGirl.create :pre_registration_fees_percentage, tournament: t1
      FactoryGirl.create :host_paypal_account, tournament: t1
      FactoryGirl.create :enable_paypal_payment, tournament: t1
    end

    it 'lists a pre-registration line item' do
      tournament = TournamentRegistration.new.tap { |t| t.visit }
      tournament.payment_details.should have_preregistration_fees
    end

    it 'allows payment via PayPal' do
      tournament = TournamentRegistration.new.tap { |t| t.visit }
      tournament.payment_details.should have_preregistration_paypal_link
      tournament.payment_details.pre_registration_row[1].should =~ /#{registration.balance_pre_registration_fees}/
      completed_payment = tournament.click_preregistration_paypal_link
      completed_payment.amount.should =~ /#{registration.balance_pre_registration_fees}/
    end

  end


end
