require "spec_helper"

describe InstitutionsController do
  describe "routing" do

    it "routes to #index" do
      get("/institutions").should route_to("institutions#index")
    end

    it "routes to #new" do
      get("/institutions/new").should route_to("institutions#new")
    end

    it "routes to #create" do
      post("/institutions").should route_to("institutions#create")
    end
  end
end
