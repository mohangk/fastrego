#TODO move currency to a setting
require 'spec_helper'

describe Payment do
  subject { FactoryGirl.create(:payment) }
  it { should belong_to(:registration) }
  it { should validate_presence_of(:registration) }
  it { should validate_presence_of(:account_number) }
  it { should validate_presence_of(:amount_sent) }
  it { should validate_presence_of(:date_sent) }
  it { should validate_numericality_of(:amount_sent) }
  it { should validate_numericality_of(:amount_received) }
  it { should have_attached_file(:scanned_proof) }
  it { should validate_attachment_presence(:scanned_proof) }
  it { should validate_attachment_content_type(:scanned_proof).
                  allowing('image/png', 'image/gif','image/jpg', 'application/pdf') }
  it { should validate_attachment_size(:scanned_proof).
                  less_than(3.megabytes) }
end