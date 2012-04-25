require 'spec_helper'
describe Enquiry do
  subject { Enquiry.new }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:institution) }
  #it { should validate_presence_of( :phone_number }
  it { should validate_presence_of(:tournament) }
  it { should validate_presence_of(:tournament_description) }
  it { should validate_presence_of(:tournament_type) }
  it { should validate_presence_of(:expected_teams) }
  it { should validate_presence_of(:expected_adjudicators) }
  #it { should validate_presence_of( :expected_independent_adjudicators }
  #it { should validate_presence_of( :tournament_url }
  it { should validate_presence_of(:tournament_registration_start_date) }
 it { should validate_presence_of(:tournament_start_date) }
end
