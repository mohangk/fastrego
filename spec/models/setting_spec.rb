require 'spec_helper'


describe Setting do
  before do
    Factory(:enable_pre_registration)
  end
  it { should validate_presence_of :key }
  it { should validate_uniqueness_of :key }
  it 'has the ability to expose the values in the key column as methods of the Setting class' do
    Setting.enable_pre_registration.should == 'True'
  end

  it 'returns nil if the setting does not exist in the model' do
    Setting.does_not_exist.should == nil
  end
end
