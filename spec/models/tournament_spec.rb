require 'spec_helper'

describe Tournament do

 subject { FactoryGirl.create(:t1_tournament) }
 it { should belong_to(:admin_user) }
 it { should validate_presence_of(:name) }
 it { should validate_presence_of(:identifier) }
 it { should validate_uniqueness_of :identifier }
 it { should have_many(:settings) }
 it { should have_many(:registrations) }
end
