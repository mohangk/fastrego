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
  
  describe 'initialize data attr' do
    it 'sets it to a hash' do
      Participant.new.data.should == {}
    end

    context 'when used as a nested attribute' do

      it 'set it to a hash' do
        test_attributes = {
          "adjudicators_attributes" =>
             {"0"=>{"name"=>"Mohan",
                    "gender"=>"Male",
                    "email"=>"test@email.com",
                    "emergency_contact_person"=>"test",
                    "emergency_contact_number"=>"123123",
                    "preferred_roommate"=>"",
                    "preferred_roommate_institution"=>"",
                    "tshirt_size"=>"tshirt large",
                    "debate_experience"=>"lots of experience"}}} 
        r = FactoryGirl.create(:registration)
        r.update_attributes(test_attributes)
      end
    end
  end

  describe 'custom fields' do
    let(:observer) do 
      FactoryGirl.create :observer
    end
    
    it 'returns nil when custom field has not been set' do
      observer.debate_experience.should == nil
    end

    it 'recognizes changes to the custom fields' do
      observer.debate_experience = 5
      observer.data_changed?.should == true
      observer.save!
      observer.data_changed?.should == false 
      observer.tshirt_size = 'new field test' 
      observer.data_changed?.should == true 
    end

    it 'persists the custom fields' do
      observer.debate_experience = 'lots of experience'
      observer.save!
      observer_id = observer.id
      o = Observer.find(observer_id)
      o.debate_experience.should == 'lots of experience'
    end

  end
end



