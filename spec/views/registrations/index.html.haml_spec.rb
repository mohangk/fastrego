require 'spec_helper'

describe "registrations/index" do
  before(:each) do
    assign(:registrations, [
      stub_model(Registration,
        :debate_team_requested => 1,
        :adjudicators_requested => 1,
        :observers_requested => 1,
        :debate_teams_granted => 1,
        :adjudicators_granted => 1,
        :observers_granted => 1,
        :debate_teams_confirmed => 1,
        :observers_confirmed => 1,
        :adjudicators_confirmed => 1,
        :user_id => 1
      ),
      stub_model(Registration,
        :debate_team_requested => 1,
        :adjudicators_requested => 1,
        :observers_requested => 1,
        :debate_teams_granted => 1,
        :adjudicators_granted => 1,
        :observers_granted => 1,
        :debate_teams_confirmed => 1,
        :observers_confirmed => 1,
        :adjudicators_confirmed => 1,
        :user_id => 1
      )
    ])
  end

  it "renders a list of registrations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
