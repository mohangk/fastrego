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

  describe 'custom fields' do
    let(:observer) do 
      FactoryGirl.create :observer
    end
    
    it 'returns nil when custom field has not been set' do
      observer.debate_experience.should == nil
    end

    it 'reconginizes changes to the custom fields' do
      observer.debate_experience = 5
      observer.data_changed?.should == true
      observer.save!
      observer.data_changed?.should == false 
      observer.tshirt_size = 'new field test' 
      observer.data_changed?.should == true 
    end
  end
end




