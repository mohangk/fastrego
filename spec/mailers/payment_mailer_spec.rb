require "spec_helper"

describe PaymentMailer do
  let(:payment) { FactoryGirl.create(:payment, amount_received: 1000, admin_comment: 'This is a comment' ) }
  let(:tournament) { payment.registration.tournament }
  let(:mail) { PaymentMailer.update_notification(payment) }

  before do
    FactoryGirl.create :tournament_registration_email, tournament: tournament
    PaymentMailer.default from: Setting.key(tournament, 'tournament_registration_email')
  end

  pending "generates absolute urls to the right tournament subdomain"

  it "has the right subject" do
    mail.subject.should == "[#{tournament.identifier}] Payment update notification"
  end

  it 'renders the receiver email' do
    mail.to.should == [payment.registration.team_manager.email]
  end

  it 'renders the sender email' do
    mail.from.should == [Setting.key(tournament, 'tournament_registration_email')]
  end

  describe 'email contents' do
    it 'contains payees name' do
      mail.body.encoded.should match(payment.registration.team_manager.name)
    end

    it 'contains payment details' do
      %w'date_sent account_number amount_sent comments amount_received admin_comment'.each do |attrib|
        mail.body.encoded.should match(payment.send(attrib).to_s)
      end
    end
  end

end
