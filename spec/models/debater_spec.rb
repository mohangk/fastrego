require 'spec_helper'

describe Debater do

  before :each do
    @registration = FactoryGirl.create(:registration)
    @second_t2 = FactoryGirl.create(:debater, registration: @registration, name: '2nd speaker team 2', speaker_number: 2, team_number: 2)
    @first_t2 = FactoryGirl.create(:debater, registration: @registration, name: '1st speaker team 2', speaker_number: 1, team_number: 2)
    @third_t1 = FactoryGirl.create(:debater, registration: @registration, name: '3rd speaker team 1', speaker_number: 3, team_number: 1)
  end

  it { should belong_to :registration }
  it { should validate_presence_of :registration }
  it { should validate_presence_of :speaker_number }
  it { should validate_presence_of :team_number }

  subject { Debater.where(team_number: 1).first }
  describe '#team_name' do
  	it 'should return the institution abbreviation concatenated with team_number' do
  		subject.team_name.should == "#{subject.registration.user.institution.abbreviation} 1"
  	end
  end

describe '.for_team :registration_id, :team_number' do
  it 'returns debaters for a registration that belongs to the team_number' do
    Debater.for_team(@registration.id, 2).should include(@second_t2, @first_t2)
    Debater.for_team(@registration.id, 2).should_not include(@third_t1)
  end

end

  pending 'it should validate uniqueness of speaker numbers within a team'
  pending 'it should validate that the amount of speakers per team do not exceed system speaker count setting'
end
