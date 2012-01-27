require 'spec_helper'

describe "institutions/show" do
  before(:each) do
    @institution = assign(:institution, stub_model(Institution,
      :name => "Name",
      :abbreviation => "Abbreviation",
      :website => "Website",
      :country => "Country"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Abbreviation/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Website/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Country/)
  end
end
