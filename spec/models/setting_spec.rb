require 'spec_helper'

describe Setting do

  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:t1_setting) { FactoryGirl.create(:enable_pre_registration, tournament: t1) }
  it { should belong_to(:tournament) }
  it { should validate_presence_of :key }
  it { should validate_presence_of :tournament_id }
  it { should validate_uniqueness_of(:key).scoped_to(:tournament_id) }

  describe '.for_tournament' do

    let!(:t2) { FactoryGirl.create(:t2_tournament) }
    let!(:t2_setting) { FactoryGirl.create(:enable_pre_registration, tournament: t2) }
    it 'returns settings for the tournament only' do
      Setting.for_tournament(t2.identifier, t2.admin_user).map(&:id).should =~ [t2_setting.id]    
    end
  end
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
