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
    assign(:search, Institution.ransack())
    assign(:countries, ["Country"])
  end

  it "renders a list of institutions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Abbreviation".to_s, :count => 2
    assert_select "tr>td", :text => "Website".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
  end
end
