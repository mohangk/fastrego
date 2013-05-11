require 'spec_helper'

describe 'users/_paypal_payment_table' do

  let(:t1) { FactoryGirl.create(:t1_tournament) }
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    view.extend MockHelperMethods
    user.confirm!
    user
    @registration = FactoryGirl.create(:granted_registration, tournament:t1, team_manager: user)
  end

  context 'when there are no paypal payments' do
    before :each do
      FactoryGirl.create(:manual_payment, registration: @registration)
    end

    it 'should be empty' do
      render
      rendered.should_not match /PayPal payment history/
    end
  end

  context 'when there is a paypal payment' do
    let!(:paypal_payment) { FactoryGirl.create(:paypal_payment, amount_sent: 50, amount_received: 50, fastrego_fees: 5, registration: @registration) }

    before :each do
      FactoryGirl.create(:manual_payment, registration: @registration)
    end

    it 'renders the table' do
      render
      rendered.should match /PayPal payment history/
    end

    it 'only lists paypal payments' do
      render
      header_row_count = 1
      page = Capybara::Node::Simple.new(rendered)
      page.all('.paypal-payment-history tr').should have(1 + header_row_count).row
    end

    it 'should contain a table of paypal payments' do
      render
      rendered.should have_css("table")
      rendered.should have_css("td", text: paypal_payment.created_at.to_s, count:1)
      rendered.should have_css("td", text: 'RM45', count:1)
      rendered.should have_css("td", text: 'RM5', count:1)
      rendered.should have_css("td", text: 'Draft', count:1)
    end
  end
end
