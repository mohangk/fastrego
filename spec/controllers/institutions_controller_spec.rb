require 'spec_helper'



describe InstitutionsController do

  # This should return the minimal set of attributes required to create a valid
  # Institution. As you add validations to Institution, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { name: 'test name',
      abbreviation: 'test abbreviation',
      country: 'Malaysia'
    }
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # InstitutionsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all institutions as @institutions" do
      institution = Institution.create! valid_attributes
      get :index, {}, valid_session
      assigns(:institutions).should eq([institution])
    end
  end

  describe "GET show" do
    it "assigns the requested institution as @institution" do
      institution = Institution.create! valid_attributes
      get :show, {:id => institution.to_param}, valid_session
      assigns(:institution).should eq(institution)
    end
  end

  describe "GET new" do
    it "assigns a new institution as @institution" do
      get :new, {}, valid_session
      assigns(:institution).should be_a_new(Institution)
    end
  end

  describe "GET edit" do
    it "assigns the requested institution as @institution" do
      institution = Institution.create! valid_attributes
      get :edit, {:id => institution.to_param}, valid_session
      assigns(:institution).should eq(institution)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Institution" do
        expect {
          post :create, {:institution => valid_attributes}, valid_session
        }.to change(Institution, :count).by(1)
      end

      it "assigns a newly created institution as @institution" do
        post :create, {:institution => valid_attributes}, valid_session
        assigns(:institution).should be_a(Institution)
        assigns(:institution).should be_persisted
      end

      it "redirects to the institution list" do
        post :create, {:institution => valid_attributes}, valid_session
        response.should redirect_to(institutions_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved institution as @institution" do
        # Trigger the behavior that occurs when invalid params are submitted
        Institution.any_instance.stub(:save).and_return(false)
        post :create, {:institution => {}}, valid_session
        assigns(:institution).should be_a_new(Institution)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Institution.any_instance.stub(:save).and_return(false)
        post :create, {:institution => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested institution" do
        institution = Institution.create! valid_attributes
        # Assuming there are no other institutions in the database, this
        # specifies that the Institution created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Institution.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => institution.to_param, :institution => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested institution as @institution" do
        institution = Institution.create! valid_attributes
        put :update, {:id => institution.to_param, :institution => valid_attributes}, valid_session
        assigns(:institution).should eq(institution)
      end

      it "redirects to the institution" do
        institution = Institution.create! valid_attributes
        put :update, {:id => institution.to_param, :institution => valid_attributes}, valid_session
        response.should redirect_to(institution)
      end
    end

    describe "with invalid params" do
      it "assigns the institution as @institution" do
        institution = Institution.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Institution.any_instance.stub(:save).and_return(false)
        put :update, {:id => institution.to_param, :institution => {}}, valid_session
        assigns(:institution).should eq(institution)
      end

      it "re-renders the 'edit' template" do
        institution = Institution.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Institution.any_instance.stub(:save).and_return(false)
        put :update, {:id => institution.to_param, :institution => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

end
