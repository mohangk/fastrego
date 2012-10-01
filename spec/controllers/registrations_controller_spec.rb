require 'spec_helper'

describe RegistrationsController do

  it 'requires authentication' do
    post :create, registration: {}
    response.status.should == 302
  end

  context 'logged in users' do

    let(:user) { FactoryGirl.create(:user) }
    let(:institution) { FactoryGirl.create(:institution) }
    let(:tournament) { FactoryGirl.create(:t1_tournament) }

    before :each do 
      user.confirm!
      sign_in user  
      controller.stub(:current_subdomain).and_return(tournament.identifier)
    end
    
    describe 'GET registration' do
      
      it 'instatiates the appropriate instituion and tournament' do
        get :new, { institution_id: institution.id  }

        assigns(:institution).should ==  institution
        assigns(:tournament).should == tournament
      end

      it 'renders new' do
        get :new, { institution_id: institution.id  }
      end

      context 'if instituion_id is not provided' do
        it 'redirects to institutions_path' do
          get :new, {}
          response.should redirect_to(institutions_path)
        end
      end

    end

    describe 'POST registration' do

      it "creates an instance of registration" do
        post :create, { institution_id: institution.id  }
        assigns(:registration).team_manager.should == user
        assigns(:registration).institution_id.should == institution.id
        assigns(:registration).tournament.should == tournament
      end 

      it "creates a new registration for the specified user" do
        expect {
          post :create, { institution_id: institution.id }
        }.to change(Registration, :count).by(1)
      end

      it 'redirects to the profile page'  do
        post :create, { institution_id: institution.id }
        response.should redirect_to(profile_path)
      end

      context 'when there are errors' do
        it 'forwards back to institution list' do
          post :create, {}
          response.should redirect_to(institutions_path)
        end
      end
    end
  end

end

