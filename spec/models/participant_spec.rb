require 'spec_helper'

describe Participant do

  let(:r)  { FactoryGirl.create :registration, tournament: FactoryGirl.create(:t2_tournament) }

  before :each do
    FactoryGirl.create(:observer, registration: r)
  end

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
    pending 'it disallows similar email addresses in the same tournament'

    it 'sets it to a hash' do
      Participant.new.data.should == {}
    end

    context 'when used as a nested attribute' do
      it 'accepts the custom fields as a nested hash' do
        test_attributes = {
          "adjudicators_attributes" =>
             {"0"=>{ 
                    "name"=>"Mohan",
                    "gender"=>"Male",
                    "email"=>"test@email.com",
                    "dietary_requirement"=>"test",
                    "emergency_contact_person"=>"test",
                    "emergency_contact_number"=>"123123",
                    "preferred_roommate"=>"",
                    "preferred_roommate_institution"=>"",
                    "tshirt_size"=>"tshirt large",
                    "registration_id" => r.id,
                    "debate_experience"=>"lots of experience"}}} 
        r.update_attributes(test_attributes).should == true
        r.reload
        r.adjudicators[0].tshirt_size.should == "tshirt large"
        r.adjudicators[0].debate_experience.should == "lots of experience"
        test_attributes['adjudicators_attributes']['0']['tshirt_size'] = 'tshirt small'
        test_attributes['adjudicators_attributes']['0']['id'] = r.adjudicators[0].id
        r.adjudicators_attributes = test_attributes['adjudicators_attributes']
                                                    
        r.save!
        r.reload
        r.adjudicators.size == 1
        r.adjudicators[0].tshirt_size.should == "tshirt small"
      end
    end
  end

  describe 'custom fields' do
    let(:observer) do 
      FactoryGirl.create :custom_field_observer, registration: r
    end
    
    it 'returns nil when custom field has not been set' do
      observer = FactoryGirl.create :observer, registration: r
      observer.debate_experience.should == nil
    end

    it 'recognizes changes to the custom fields' do
      observer.debate_experience.should == '5'
      observer.debate_experience = '50'
      observer.data_changed?.should == true
      observer.save!
      observer.reload
      observer.debate_experience.should == '50'
      observer.data_changed?.should == false 
      observer.tshirt_size = 'new field test' 
      observer.data_changed?.should == true 
      observer.save!
      observer.reload
      observer.tshirt_size.should == 'new field test'
    end

    it 'allows custom fields to be updated' do
      observer.reload
      observer.debate_experience.should == '5'
      observer.debate_experience = '50'
      observer.save!
      observer.reload
      observer.debate_experience.should == '50'
    end

    it 'persists the custom fields' do
      observer.debate_experience = 'lots of experience'
      observer.save!
      observer_id = observer.id
      o = Observer.find(observer_id)
      o.debate_experience.should == 'lots of experience'
    end

  end
  
  describe '#respond_to?' do
    context 'where there are no custom fields set' do
      let(:observer) { FactoryGirl.create :observer, registration: r }
      before do
        stub_const('Participant::CUSTOM_FIELDS', {})
      end
    
      it 'still works' do
        observer.respond_to?(:name).should be_true
      end
    end
  end
end



