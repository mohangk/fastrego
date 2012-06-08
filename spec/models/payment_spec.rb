#TODO move currency to a setting
require 'spec_helper'

describe Payment do
  subject { FactoryGirl.create(:payment) }
  it { should belong_to(:registration) }
  it { should validate_presence_of(:registration) }
  it { should validate_presence_of(:account_number).with_message(/can't be blank/)}
  it { should validate_presence_of(:amount_sent).with_message(/can't be blank/) }
  it { should validate_presence_of(:date_sent) }
  it { should validate_numericality_of(:amount_sent) }
  it { should validate_numericality_of(:amount_received) }
  it { should have_attached_file(:scanned_proof) }
  it { should validate_attachment_presence(:scanned_proof) }
  it { should validate_attachment_content_type(:scanned_proof).
                  allowing('image/png', 'image/gif','image/jpeg', 'application/pdf') }
  it { should validate_attachment_size(:scanned_proof).
                  less_than(3.megabytes) }
 it { should_not allow_mass_assignment_of(:amount_received)}
 it { should_not allow_mass_assignment_of(:admin_comment)}
 it { should_not allow_mass_assignment_of(:registration_id)}
 it { should have_db_column(:amount_received).of_type(:decimal).with_options(precision: 14, scale:2) }
 it { should have_db_column(:amount_sent).of_type(:decimal).with_options(precision: 14, scale:2) }

  it 'is confirmed if either the amount_received or admin_comment is set' do
    subject.amount_received = 1000
    subject.confirmed?.should == true

    subject.amount_received = nil
    subject.admin_comment = 'test comment'
    subject.confirmed?.should == true
  end

  describe '#send_payment_notification' do
    it 'will send an email with latest payment details' do
      subject.send_payment_notification
      ActionMailer::Base.deliveries.last.to.should == [subject.registration.user.email]
    end
  end
end
