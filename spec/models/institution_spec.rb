require 'spec_helper'

describe Institution do
  subject { Factory(:institution) }
  it { should ensure_length_of(:abbreviation).is_at_most(10) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:abbreviation) }
  it { should validate_presence_of(:country) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:abbreviation) }

  it "should strip attributes with whitespaces" do
    subject
    lambda {Institution.create!(abbreviation: 'MMU ', name: 'Fake MMU', country: 'Test')}.should raise_error ActiveRecord::RecordInvalid
  end

  it "should list institution alphabetically" do
    Factory(:institution, name: 'Zztop', abbreviation: 'zz')
    Factory(:institution)
    Factory(:institution, name: 'Aatop', abbreviation: 'aa')
    Factory(:institution, name: 'Bbtop', abbreviation: 'cc')

    institutions = Institution.alphabetically
    institutions[0].name.should == 'Aatop'
    institutions[1].name.should == 'Bbtop'
    institutions[2].name.should == 'Multimedia University'
    institutions[3].name.should == 'Zztop'
  end
end
