require 'spec_helper'

describe DebatersController do 

  before :each do
  	user.confirm!
    sign_in user
    #stub Settings.key('debate_team_size')
    Settings.stub(:key).and_return(3)
  end

  let(:user) { FactoryGirl.create(:registration, debate_teams_confirmed: 2).user}

  describe '#edit' do

  end

end