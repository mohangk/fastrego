require "spec_helper"

describe RegistrationsController do
  describe "routing" do

    it "routes to #index" do
      get("/registrations").should route_to("registrations#index")
    end

    it "routes to #new" do
      get("/registrations/new").should route_to("registrations#new")
    end

    it "routes to #show" do
      get("/registrations/1").should route_to("registrations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/registrations/1/edit").should route_to("registrations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/registrations").should route_to("registrations#create")
    end

    it "routes to #update" do
      put("/registrations/1").should route_to("registrations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/registrations/1").should route_to("registrations#destroy", :id => "1")
    end

  end
end
