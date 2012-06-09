require 'spec_helper'

describe Participant do
  it { should validate_presence_of :name }
  it { should belong_to(:registration) }
  it { should validate_presence_of :registration }
  it { should validate_presence_of :gender }
  it { should validate_presence_of :email }
  it { should validate_presence_of :dietary_requirement }
  it { should validate_presence_of :emergency_contact_person }
  it { should validate_presence_of :emergency_contact_number }
  it { should have_db_column(:data).of_type(:hstore) }
end




