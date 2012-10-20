require 'spec_helper'

describe UsersController do

  before(:each) do
    user.confirm!
    sign_in user
  end

  describe 'GET edit_debaters' do
    before :each do
      FactoryGirl.create(:debate_team_size, value:1)
      get :edit_debaters
    end

    let(:user) do
      FactoryGirl.create(:registration, debate_teams_confirmed: 3).user
    end

    context 'no debaters created yet' do
      it 'assigns the current_users registration as @registration' do
        assigns(:registration).should == user.registration
      end

      it 'should render the edit_debaters' do
        response.should render_template(:edit_debaters)
      end
    end

    pending 'must disallow access if not debate_teams_confirmed is not set'
  end

  describe 'PUT update_debaters' do

    let(:user) do
      #set to a contrived one speaker teams to reduce test fixtures
      FactoryGirl.create(:registration, debate_teams_confirmed: 1).user
    end
    

    context 'with valid parameters' do

      let(:request)  { put :update_debaters, {registration: {  debaters_attributes: [FactoryGirl.attributes_for(:debater)]}}}


      it 'assigns the current_users registration as @registration' do
        request  
        assigns(:registration).should == user.registration
      end

      it 'creates a new debater' do
        expect {
          request
        }.to change(Debater, :count).by(1)
      end

      pending 'must disallow put-ing if not debate_teams_confirmed is not set'
      pending 'must validate that the count does not exceed the allocatated debate_teams_confirmed'

      it 'redirects to profile_url' do
        request
        response.should redirect_to(profile_path)
      end
    end

    context 'with invalid parameters' do

      let(:request) { put :update_debaters, {registration: {debaters_attributes: [FactoryGirl.attributes_for(:debater), name:'']}} }
      it 'does not create a new debater' do
        expect {
          request
        }.to change(Debater, :count).by(0)
      end

      it 'renders edit_debaters' do
        request
        response.should render_template(:edit_debaters)
      end
    end
  end
  pending 'handle users trying to access the participant forms before the confirmed quantites being set'
end
