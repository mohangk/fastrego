require 'spec_helper'

describe 'users/_payment_table' do
  context 'when there are no payments' do
    before :each do
      user = FactoryGirl.create(:registration).user
      user.confirm!
      sign_in user
    end
    it 'should be empty' do
      render
      should_not have_css('table')
    end
  end
  context 'when there is a payment' do


    context 'that is not confirmed' do

      before :each do
        user = FactoryGirl.create(:payment).registration.user
        user.confirm!
        sign_in user
      end

      it 'should contain a table of payments' do
        render
        rendered.should have_css('table')
        rendered.should have_css('td', text: 'AB1231234', count:1)
        rendered.should have_css('td', text: 'RM12,000.00', count:1)
        rendered.should have_css('td', text: '2011-12-12', count:1)
        rendered.should have_css('td', text: 'Total payment - arriba!', count:1)
        rendered.should have_css("td a[href*='test_image.jpg']", text: 'View', count:1)
        rendered.should have_css("td a[data-method='delete']", text: 'Delete', count:1)
      end
    end

    #context 'that is confirmed' do
    #
    #  before :each do
    #    user = FactoryGirl.create(:payment, amount_received: 1000, admin_comment: 'Not complete dude!').registration.user
    #    user.confirm!
    #    sign_in user
    #  end
    #
    #
    #  it 'should contain a table of payments' do
    #    render
    #    rendered.should have_css('table')
    #    rendered.should have_css('td', text: 'AB1231234', count:1)
    #    rendered.should have_css('td', text: '12000', count:1)
    #    rendered.should have_css('td', text: '2011-12-12', count:1)
    #    rendered.should have_css('td', text: 'Total payment - arriba!', count:1)
    #    rendered.should have_css('td', text: 'Total payment - arriba!', count:1)
    #    rendered.should have_css('td', text: 'Total payment - arriba!', count:1)
    #    rendered.should have_css("td a[href*='test_image.jpg']", text: 'View', count:1)
    #    rendered.should have_css("td a[data-method='delete']", text: 'Delete', count:1)
    #  end
    #end

  end
end