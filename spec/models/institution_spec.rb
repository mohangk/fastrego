require 'spec_helper'

describe Institution do
  subject { Factory(:institution) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:abbreviation) }
  it { should validate_presence_of(:country) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:abbreviation) }
  it { should validate_uniqueness_of(:country) }
end
