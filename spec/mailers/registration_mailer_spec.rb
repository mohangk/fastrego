require "spec_helper"

describe RegistrationMailer do
  let(:registration) { 
      FactoryGirl.create(:registration, 
                         debate_teams_granted: 5, 
                         debate_teams_confirmed: 3, 
                         adjudicators_granted: 4, 
                         adjudicators_confirmed: 9, 
                         observers_granted: 6, 
                         observers_confirmed: 8) }
  let(:slots_granted_mail) { RegistrationMailer.slots_granted_notification(registration) }
  let(:slots_confirmed_mail) { RegistrationMailer.slots_confirmed_notification(registration) }

  before do
    RegistrationMailer.default from: 'do-not-reply@uadc2012.mailgun.org'
  end


  it "has the right subject" do
    slots_granted_mail.subject.should == 'Granted slots notification'
    slots_confirmed_mail.subject.should == 'Confirmed slots notification'
  end

  it 'renders the receiver email' do
    slots_granted_mail.to.should == [registration.user.email]
    slots_confirmed_mail.to.should == [registration.user.email]
  end

  it 'renders the sender email' do
    slots_granted_mail.from.should == ['do-not-reply@uadc2012.mailgun.org']
    slots_confirmed_mail.from.should == ['do-not-reply@uadc2012.mailgun.org']
  end

  describe 'email contents' do
    it 'contains institutions name' do
      slots_granted_mail.body.encoded.should match(registration.user.institution.name)

      slots_confirmed_mail.body.encoded.should match(registration.user.institution.name)
    end

    it 'contains registration details' do
      %w'debate_teams_granted adjudicators_granted observers_granted'.each do |attrib|
        slots_granted_mail.body.encoded.should match(registration.send(attrib).to_s)
      end
      %w'debate_teams_confirmed adjudicators_confirmed observers_confirmed'.each do |attrib|
        slots_confirmed_mail.body.encoded.should match(registration.send(attrib).to_s)
      end

    end
  end

end
