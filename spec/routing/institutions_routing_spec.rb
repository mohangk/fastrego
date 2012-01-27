require "spec_helper"

describe InstitutionsController do
  describe "routing" do

    it "routes to #index" do
      get("/institutions").should route_to("institutions#index")
    end

    it "routes to #new" do
      get("/institutions/new").should route_to("institutions#new")
    end

    it "routes to #show" do
      get("/institutions/1").should route_to("institutions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/institutions/1/edit").should route_to("institutions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/institutions").should route_to("institutions#create")
    end

    it "routes to #update" do
      put("/institutions/1").should route_to("institutions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/institutions/1").should route_to("institutions#destroy", :id => "1")
    end

  end
end
