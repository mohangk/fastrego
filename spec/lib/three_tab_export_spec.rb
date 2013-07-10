require 'spec_helper'

describe 'ThreeTabExport' do

  let(:registration) { FactoryGirl.create :complete_registration }

  describe 'Institution' do
    it 'generates a valid institution export' do
      csv = ThreeTabExport::Institution.new
      csv.each_registration registration
      expect(csv.string).to eq "code,name\n#{registration.institution.abbreviation},Multimedia University 1\n"
    end
  end

  describe 'Adjudicator' do
    it 'generates a valid adjudicator export' do
      csv = ThreeTabExport::Adjudicator.new
      csv.each_registration registration
      expect(csv.string).to eq "institution-code,name,test_score,active\n#{registration.institution.abbreviation},#{registration.adjudicators.first.name},,\n"
    end
  end

  describe 'Team' do
    it 'generates a valid team export' do
      csv = ThreeTabExport::Team.new
      csv.each_registration registration
      expect(csv.string).to eq "institution-code,name,active,swing\n#{registration.institution.abbreviation},#{registration.institution.abbreviation} 1,,\n"
    end
  end

  describe 'Debater' do
    it 'generates a valid team export' do
      csv = ThreeTabExport::Debater.new
      csv.each_registration registration
      expect(csv.string).to eq "team-name,name\n#{registration.institution.abbreviation} 1,#{registration.debaters.first.name}\n"
    end
  end

  describe '.generate' do

    it 'creates the export zip file' do

      ThreeTabExport.generate_zip(registration.tournament)

    end

  end

end
