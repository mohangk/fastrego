require 'spec_helper'

describe 'users/edit_debaters.html.haml' do


  let(:registration) do
    r = FactoryGirl.create(:registration, debate_teams_confirmed: 2)
  end

  before(:each) do
    FactoryGirl.create(:debate_team_size)
  end

  context 'when no debaters are assigned yet' do
    it 'will render debate_teams X debate_speaker_count forms' do
      assign :registration, registration
  	  render
  	  #puts rendered
  	  rendered.should have_content('MMU 1')
  	  rendered.should have_content('Speaker 1')
  	  rendered.should have_content('Speaker 2')
  	  rendered.should have_content('Speaker 3')
  	  rendered.should have_content('MMU 2')
  	  rendered.should have_content('Speaker 1')
  	  rendered.should have_content('Speaker 2')
  	  rendered.should have_content('Speaker 3')
    end
  end

end