require 'spec_helper'

describe "Custom field support" do

  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:t2) { FactoryGirl.create(:t2_tournament) }
  let!(:currency_symbol) { FactoryGirl.create(:currency_symbol, tournament: t1) }
  let!(:mmu) { FactoryGirl.create(:institution) }
  let!(:utm) { FactoryGirl.create(:institution, name: 'Universiti Teknologi', abbreviation: 'UTM') }


  describe 'custom participant fields for t1' do
    before :each do
      FactoryGirl.create :debate_team_size, tournament: t1
      r = FactoryGirl.create :confirmed_registration, institution: mmu, tournament: t1 
      user_login t1, r.team_manager.email, 'password'
      visit profile_path
    end

    it 'correctly displays the form with the custom fields' do
      tournament = TournamentRegistration.new.tap { |t| t.visit }
      debate_team_form = tournament.add_debate_team_details
      debate_team_form.correct_page?
      debate_team_form.should have_field 'Accomodation'
      debate_team_form.should_not have_field 'Debate experience'
      debate_team_form.should_not have_field 'Tshirt size'
    end
  end

  describe 'custom participant fields for t2' do

    before :each do
      FactoryGirl.create :debate_team_size, tournament: t2
      r = FactoryGirl.create :confirmed_registration, institution: mmu, tournament: t2 
      user_login t2, r.team_manager.email, 'password'
      visit profile_path
    end

    it 'correctly displays only accomodation' do
      tournament = TournamentRegistration.new.tap { |t| t.visit }
      debate_team_form = tournament.add_debate_team_details
      debate_team_form.correct_page?
      debate_team_form.should have_field 'Debate experience'
      debate_team_form.should have_field 'Tshirt size'
      debate_team_form.should_not have_field 'Accomodation'
    end
  end
end
