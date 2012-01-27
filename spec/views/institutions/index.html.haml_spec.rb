require 'spec_helper'

describe "institutions/index" do
  before(:each) do
    assign(:institutions, [
      stub_model(Institution,
        :name => "Name",
        :abbreviation => "Abbreviation",
        :website => "Website",
        :country => "Country"
      ),
      stub_model(Institution,
        :name => "Name",
        :abbreviation => "Abbreviation",
        :website => "Website",
        :country => "Country"
      )
    ])
  end

  it "renders a list of institutions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Abbreviation".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Country".to_s, :count => 2
  end
end
