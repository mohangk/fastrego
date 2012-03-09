require "spec_helper"

describe PaymentMailer do
  let(:payment) { FactoryGirl.create(:payment, amount_received: 1000, admin_comment: 'This is a comment' ) }
  let(:mail) { PaymentMailer.update_notification(payment) }

  it "has the right subject" do
    mail.subject.should == 'Payment update notification'
  end

  it 'renders the receiver email' do
    mail.to.should == [payment.registration.user.email]
  end

  it 'renders the sender email' do
    mail.from.should == ['do-not-reply@uadc2012.mailgun.org']
  end

  describe 'email contents' do
    it 'contains payees name' do
      mail.body.encoded.should match(payment.registration.user.name)
    end

    it 'contains payment details' do
      %w'date_sent account_number amount_sent comments amount_received admin_comment'.each do |attrib|
        mail.body.encoded.should match(payment.send(attrib).to_s)
      end
    end
  end

end
