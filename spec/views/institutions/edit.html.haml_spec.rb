require 'spec_helper'

describe "institutions/edit" do
  before(:each) do
    @institution = assign(:institution, stub_model(Institution,
      :name => "MyString",
      :abbreviation => "MyString",
      :website => "MyString",
      :country => "MyString"
    ))
  end

  it "renders the edit institution form" do
    render
    assert_select "form", :action => institutions_path(@institution), :method => "post" do
      assert_select "input#institution_name", :name => "institution[name]"
      assert_select "input#institution_abbreviation", :name => "institution[abbreviation]"
      assert_select "input#institution_website", :name => "institution[website]"
      assert_select "select#institution_country", :name => "institution[country]"
    end
  end
end
