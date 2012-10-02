require 'spec_helper'

describe "Homepage" do
  describe 'accessing the FastRego homepage' do

    before(:each) do
      FactoryGirl.create(:t1_tournament) 
      FactoryGirl.create(:t2_tournament) 
    end

    it 'has a list of active tournaments' do
      set_subdomain ''
      visit '/'
      page.should have_content 'tournament 1'
      page.should have_content 'tournament 2'
    end
  end

  describe 'acessing a tournament subdomain that does not exist' do
    pending 'forwards back to homepage'
  end
end
