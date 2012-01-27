require 'spec_helper'

describe "institutions/new" do
  before(:each) do
    assign(:institution, stub_model(Institution,
      :name => "MyString",
      :abbreviation => "MyString",
      :website => "MyString",
      :country => "MyString"
    ).as_new_record)
  end

  it "renders new institution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => institutions_path, :method => "post" do
      assert_select "input#institution_name", :name => "institution[name]"
      assert_select "input#institution_abbreviation", :name => "institution[abbreviation]"
      assert_select "input#institution_website", :name => "institution[website]"
      assert_select "input#institution_country", :name => "institution[country]"
    end
  end
end
