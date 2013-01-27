require 'spec_helper'

describe RegistrationsController do

  it 'requires authentication' do
    post :create, registration: {}
    response.status.should == 302
  end

  context 'logged in users' do

    let(:user) { FactoryGirl.create(:user) }
    let(:university) { FactoryGirl.create(:university) }
    let(:tournament) { FactoryGirl.create(:t1_tournament) }

    before :each do 
      user.confirm!
      sign_in user  
      controller.stub(:current_subdomain).and_return(tournament.identifier)
    end

    describe 'GET /new' do

      it 'instatiates the appropriate instituion and tournament' do
        get :new, { institution_id: university.id  }

        assigns(:institution).should ==  university
        assigns(:tournament).should == tournament
      end

      it 'renders new' do
        get :new, { institution_id: university.id  }
        response.should render_template 'new'
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
        post :create, { institution_id: university.id  }
        assigns(:registration).team_manager.should == user
        assigns(:registration).institution_id.should == university.id
        assigns(:registration).tournament.should == tournament
      end 

      it "creates a new registration for the specified user" do
        expect {
          post :create, { institution_id: university.id }
        }.to change(Registration, :count).by(1)
      end

      it 'redirects to the profile page'  do
        post :create, { institution_id: university.id }
        response.should redirect_to(profile_path)
      end

      context 'when there are errors' do
        it 'forwards back to institution list' do
          post :create, {}
          response.should redirect_to(institutions_path)
        end
      end
    end

    describe 'PUT registration' do

      context 'valid requests' do
        before :each do
          @registration = FactoryGirl.create :registration, tournament: tournament, institution: university
          controller.stub(:current_registration).and_return(@registration)
        end

        it "loads the appropriate registration" do
          put :update, id: @registration.id 
          assigns(:registration).should eq(@registration)
          assigns(:registration).should be_persisted
        end

        context 'request stage' do
          it "sets the requested at value of the registration" do
            now = Time.zone.local(2008, 9, 1, 12, 0, 0)
            Timecop.freeze(now) do
              put :update, id: @registration.id, registration: {}
              assigns(:registration).requested_at.should eq(now)
              @registration.reload
              @registration.requested_at.should eq(now)
            end
          end

          it "sets the requested quantities" do
            put :update, id: @registration.id, registration: { debate_teams_requested: 1, observers_requested: 3 }
            assigns(:registration).debate_teams_requested.should == 1
            assigns(:registration).adjudicators_requested.should == 0
            assigns(:registration).observers_requested.should == 3
            @registration.reload
            @registration.debate_teams_requested.should == 1
            @registration.adjudicators_requested.should == 0
            @registration.observers_requested.should == 3
          end

          it "redirects to the profile" do
            put :update, id: @registration.id, registration: { debate_teams_requested: 1,  adjudicators_requested: 2, observers_requested: 3 }
            response.should redirect_to profile_path
          end
        end
      end
      context 'invalid requests' do

        before :each do
          @registration = FactoryGirl.create :requested_registration, tournament: tournament, institution: university
        end

        it 'does not allows for double requests' do
          original_updated_at = @registration.updated_at 
          frozen_time = Time.zone.now - 1.day
          Timecop.freeze(frozen_time) do
            put :update, id: @registration.id
            @registration.reload
            @registration.requested_at.should_not == frozen_time
            @registration.updated_at.should eq(original_updated_at)
            flash[:notice].should eq('There was an error while recording your request.')
          end
        end

      end
    end


    shared_examples_for 'GET participant_form' do | action |

      before :each do
        FactoryGirl.create(:debate_team_size, value:1, tournament: tournament)
        
        @registration = FactoryGirl.create(:registration, debate_teams_confirmed: 1, adjudicators_confirmed: 1, observers_confirmed: 1,  tournament: tournament, institution: university)
        controller.stub(:current_registration).and_return(@registration)
        get action
      end

      context 'no participant created yet' do
        it 'assigns the current_users registration as @registration' do
          assigns(:registration).should == @registration
        end

        it "should render #{action}" do
          response.should render_template(action)
        end
      end

      pending 'must disallow access if not debate_teams_confirmed is not set'

      pending 'when not assigned as a team manager yet/ registration not persisted'

    end
    
    describe 'GET edit_debaters' do
      it_should_behave_like 'GET participant_form', :edit_debaters
    end

    describe 'GET edit_adjudicators' do
      it_should_behave_like 'GET participant_form', :edit_adjudicators
    end

    describe 'GET edit_observers' do
      it_should_behave_like 'GET participant_form', :edit_observers
    end

    shared_examples_for 'PUT participant_form' do |action, participant_class, template, participant_hash, invalid_participant_hash |

      before :each do
        FactoryGirl.create(:debate_team_size, value:1, tournament: tournament)
        @registration = FactoryGirl.create(:registration, debate_teams_confirmed: 1, adjudicators_confirmed: 1, observers_confirmed: 1,  tournament: tournament, institution: university)
        controller.stub(:current_registration).and_return(@registration)
      end

      context 'with valid parameters' do

        let(:request)  { put action, {registration: participant_hash }}


        it 'assigns the current_users registration as @registration' do
          request  
          assigns(:registration).should == @registration
        end

        it "creates a new #{participant_class.to_s.downcase}" do
          expect {
            request
          }.to change(participant_class, :count).by(1)
        end

        pending 'must disallow put-ing if not debate_teams_confirmed is not set'
        pending 'must validate that the count does not exceed the allocatated debate_teams_confirmed'

        it 'redirects to profile_url' do
          request
          response.should redirect_to(profile_path)
        end
      end

      context 'with invalid parameters' do

        let(:request) { put action, { registration: invalid_participant_hash } }

        it "does not create a new #{participant_class.to_s.downcase}" do
          expect {
            request
          }.to change(participant_class, :count).by(0)
        end

        it 'renders edit_debaters' do
          request
          response.should render_template(template)
        end

      end
    end

    describe 'PUT update_debaters' do

      it_should_behave_like 'PUT participant_form', :update_debaters, Debater, :edit_debaters, { :debaters_attributes => [FactoryGirl.attributes_for(:debater)] }, { :debaters_attributes => [FactoryGirl.attributes_for(:debater), name:''] }

    end

    describe 'PUT update_observers' do

      it_should_behave_like 'PUT participant_form', :update_observers, Observer, :edit_observers, { :observers_attributes=> [FactoryGirl.attributes_for(:observer)] }, { :observers_attributes => [FactoryGirl.attributes_for(:observer), name:''] }

    end

    describe 'PUT update_adjudicators' do

      it_should_behave_like 'PUT participant_form', :update_adjudicators, Adjudicator, :edit_adjudicators, { :adjudicators_attributes=> [FactoryGirl.attributes_for(:adjudicator)] }, { :adjudicators_attributes => [FactoryGirl.attributes_for(:adjudicator), name:''] }

    end

    pending 'handle users trying to access the participant forms before the confirmed quantites being set'
  end
end

