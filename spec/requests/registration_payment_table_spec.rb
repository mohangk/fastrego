require 'spec_helper'

describe 'Registration payment table spec' do

  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:currency_symbol) { FactoryGirl.create(:currency_symbol, tournament: t1) }
  let!(:mmu) { FactoryGirl.create(:institution) }


  before :each do
    r = FactoryGirl.create :granted_registration, tournament: t1
    user_login t1, r.team_manager.email, 'password'
  end


  context 'when there is a pre-registration fees set' do
    before do
      FactoryGirl.create :pre_registration_fees_percentage, tournament: t1
    end

    it 'lists a pre-registration line item' do
      tournament = TournamentRegistration.new.tap { |t| t.visit }
      tournament.payment_details.should have_preregistration_fees
    end
  end


end
