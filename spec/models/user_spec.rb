require 'spec_helper'

describe User do
  subject { Factory(:user) }
  it { should belong_to :institution }
  it { should validate_presence_of :institution_id }
  it { should validate_uniqueness_of :institution_id }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email}
end
