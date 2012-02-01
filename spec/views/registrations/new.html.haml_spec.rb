require 'spec_helper'

describe "registrations/new" do
  before(:each) do
    assign(:registration, stub_model(Registration,
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
    ).as_new_record)
  end

  it "renders new registration form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => registrations_path, :method => "post" do
      assert_select "input#registration_debate_team_requested", :name => "registration[debate_team_requested]"
      assert_select "input#registration_adjudicators_requested", :name => "registration[adjudicators_requested]"
      assert_select "input#registration_observers_requested", :name => "registration[observers_requested]"
      assert_select "input#registration_debate_teams_granted", :name => "registration[debate_teams_granted]"
      assert_select "input#registration_adjudicators_granted", :name => "registration[adjudicators_granted]"
      assert_select "input#registration_observers_granted", :name => "registration[observers_granted]"
      assert_select "input#registration_debate_teams_confirmed", :name => "registration[debate_teams_confirmed]"
      assert_select "input#registration_observers_confirmed", :name => "registration[observers_confirmed]"
      assert_select "input#registration_adjudicators_confirmed", :name => "registration[adjudicators_confirmed]"
      assert_select "input#registration_user_id", :name => "registration[user_id]"
    end
  end
end
