require 'spec_helper'

describe "users/show.html.haml" do
  before(:each) do
    sign_in Factory(:user)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Suthen Thomas/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/suthen.thomas@gmail.com/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/123123123123/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Multimedia University/)
  end
end
