require 'spec_helper'

describe 'users/_payment_table' do

  let(:t1) { FactoryGirl.create(:t1_tournament) } 
  let(:user) { FactoryGirl.create(:user) } 

  before :each do
    view.extend MockHelperMethods
    user.confirm!
    user
    @registration = FactoryGirl.create(:granted_registration, tournament:t1, team_manager: user)
  end

  context 'when there are no manual payments' do
    before :each do
      FactoryGirl.create(:paypal_payment, registration: @registration)
    end

    it 'should be empty' do
      render
      rendered.should_not match /Manual payment history/
    end
  end

  context 'when there is a manual payment' do

    before :each do
      FactoryGirl.create(:manual_payment, registration: @registration)
      FactoryGirl.create(:paypal_payment, registration: @registration)
    end

    it 'only lists manual payments' do
      render
      header_row_count = 1
      page = Capybara::Node::Simple.new(rendered)
      page.all('.manual-payment-history tr').should have(1 + header_row_count).row
    end

    it 'should contain a table of payments' do
      render
      rendered.should have_css("table")
      rendered.should have_css("td", text: 'AB1231234', count:1)
      rendered.should have_css("td", text: 'RM12,000.00', count:1)
      rendered.should have_css("td", text: '2011-12-12', count:1)
      rendered.should have_css("td", text: 'Total payment - arriba!', count:1)
      rendered.should have_css("td a[href*='test_image.jpg']", text: 'View', count:1)
      rendered.should have_css("td a[data-method='delete']", text: 'Delete', count:1)
    end
  end
end
