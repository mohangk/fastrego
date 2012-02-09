require 'spec_helper'

describe Institution do
  subject { Factory(:institution) }
  it { should ensure_length_of(:abbreviation).is_at_most(10) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:abbreviation) }
  it { should validate_presence_of(:country) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:abbreviation) }

  pending 'how to handle dependent object in the case of a deletion of an institution'
end
