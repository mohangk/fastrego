require "spec_helper"

describe RegistrationMailer do
  let!(:registration) { 
      FactoryGirl.create(:registration, 
                         debate_teams_granted: 5, 
                         debate_teams_confirmed: 3, 
                         adjudicators_granted: 4, 
                         adjudicators_confirmed: 9, 
                         observers_granted: 6, 
                         observers_confirmed: 8) }
  let(:tournament) { registration.tournament }
  let(:slots_granted_mail) { RegistrationMailer.slots_granted_notification(registration) }
  let(:slots_confirmed_mail) { RegistrationMailer.slots_confirmed_notification(registration) }
  let(:tournament_name_setting) {FactoryGirl.create(:tournament_name, tournament: tournament)} 

  before do
    tournament_name_setting 
    FactoryGirl.create(:tournament_registration_email, tournament: tournament)
    RegistrationMailer.default from: Setting.key(tournament, 'tournament_registration_email')
  end

  pending "generates absolute urls to the right tournament subdomain"

  it "has the right subject" do
    slots_granted_mail.subject.should == "[#{tournament.identifier}] Updates to your granted slots!"
    slots_confirmed_mail.subject.should == "[#{tournament.identifier}] Updates to your confirmed slots!"
  end

  it 'renders the receiver email' do
    slots_granted_mail.to.should == [registration.team_manager.email]
    slots_confirmed_mail.to.should == [registration.team_manager.email]
  end

  it 'renders the sender email' do
    slots_granted_mail.from.should == [Setting.key(tournament, 'tournament_registration_email')]
    slots_confirmed_mail.from.should == [Setting.key(tournament, 'tournament_registration_email')]
  end

  describe 'email contents' do
    it 'contains the team managers name' do
      slots_granted_mail.body.encoded.should match(registration.team_manager.name)
      slots_confirmed_mail.body.encoded.should match(registration.team_manager.name)
    end

    it 'contains institutions name' do
      slots_granted_mail.body.encoded.should match(registration.institution.name)
      slots_confirmed_mail.body.encoded.should match(registration.institution.name)
    end

    it 'contains the tournament name' do
      slots_granted_mail.body.encoded.should match(Setting.key(tournament, 'tournament_name'))
      slots_confirmed_mail.body.encoded.should match(Setting.key(tournament, 'tournament_name'))
    end

    it 'contains registration details' do
      %w'debate_teams_granted adjudicators_granted observers_granted'.each do |attrib|
        slots_granted_mail.body.encoded.should match(registration.send(attrib).to_s)
      end
      %w'debate_teams_confirmed adjudicators_confirmed observers_confirmed'.each do |attrib|
        slots_confirmed_mail.body.encoded.should match(registration.send(attrib).to_s)
      end
    end

    it 'contains our footer' do
      slots_granted_mail.body.encoded.should match('FastRego')
      slots_confirmed_mail.body.encoded.should match('FastRego')
    end
  end

end
