require 'spec_helper'

describe Setting do

  let!(:t1) { FactoryGirl.create(:enable_pre_registration).tournament }

  it { should belong_to(:tournament) }
  it { should validate_presence_of :key }
  it { should validate_presence_of :tournament_id }
  it { should validate_uniqueness_of :key }

  context 'key' do

    it 'returns the value column of the row with the corresponding "key" ' do
      Setting.key(t1, 'enable_pre_registration').should == 'True'
    end

    it 'returns nil if the "key" does not exist in the table' do
      Setting.key(t1, 'does_not_exist').should == nil
    end

    it 'creates a new row in the table when a key and value parameter is passed and the key does not exist' do
      Setting.key(t1, 'new_attribute', 'This_is_a_new_attribute')
      Setting.key(t1, 'new_attribute').should == 'This_is_a_new_attribute'
      Setting.all.should have(2).items
    end

    it 'updates the value column of the corresponding row of a "key" if it already exists' do
      Setting.key(t1, 'enable_pre_registration').should == 'True'
      Setting.key(t1, 'enable_pre_registration', 'False')
      Setting.key(t1, 'enable_pre_registration').should == 'False'
      Setting.all.should have(1).items
    end
  end

end
