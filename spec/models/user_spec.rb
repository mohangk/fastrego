require 'spec_helper'

describe User do
  subject { FactoryGirl.create(:user) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email}
  it { should have_many(:managed_registrations) }
end
