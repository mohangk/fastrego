require 'spec_helper'

describe Registration do
  before :each do
    Factory(:registration)
  end
  it { should belong_to :user }
  it { should validate_uniqueness_of :user_id }
  it { should validate_presence_of :user_id}
  it { should validate_numericality_of(:debate_teams_requested)}
  it { should validate_numericality_of(:adjudicators_requested)}
  it { should validate_numericality_of(:observers_requested)}
  it { should validate_numericality_of(:debate_teams_granted)}
  it { should validate_numericality_of(:adjudicators_granted)}
  it { should validate_numericality_of(:observers_granted)}
  it { should validate_numericality_of(:debate_teams_confirmed)}
  it { should validate_numericality_of(:adjudicators_confirmed)}
  it { should validate_numericality_of(:observers_confirmed)}
  it { should_not allow_mass_assignment_of(:debate_teams_granted)}
  it { should_not allow_mass_assignment_of(:adjudicators_granted)}
  it { should_not allow_mass_assignment_of(:observers_granted)}
  it { should_not allow_mass_assignment_of(:debate_teams_confirmed)}
  it { should_not allow_mass_assignment_of(:adjudicators_confirmed)}
  it { should_not allow_mass_assignment_of(:observers_confirmed)}
end
