require 'spec_helper'

describe 'users/_debater_form' do
	it 'should contain pre filled information about the team and speaker number' do		
		render 'users/debater_form', debater: FactoryGirl.create(:debater)
		rendered.should have_content('Team MMU 1')
		rendered.should have_content('Speaker number 1')
		rendered.should have_css('.edit_debater')
	end

end