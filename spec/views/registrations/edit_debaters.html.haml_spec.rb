require 'spec_helper'

describe 'registrations/edit_debaters.html.haml' do

  let(:registration) do
    FactoryGirl.create(:registration, debate_teams_confirmed: 2)
  end

  let!(:debate_team_size) { FactoryGirl.create(:debate_team_size, tournament: registration.tournament) }


  context 'when no debaters are assigned yet' do
    it 'will render debate_teams X debate_speaker_count forms' do
      assign :registration, registration
  	  render
  	  #puts rendered
  	  rendered.should match(/MMU\d* 1/)
  	  rendered.should have_content('Speaker 1')
  	  rendered.should have_content('Speaker 2')
  	  rendered.should have_content('Speaker 3')
  	  rendered.should match(/MMU\d* 2/)
  	  rendered.should have_content('Speaker 1')
  	  rendered.should have_content('Speaker 2')
  	  rendered.should have_content('Speaker 3')
    end
  end

end
