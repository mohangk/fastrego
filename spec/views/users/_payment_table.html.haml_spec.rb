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
  context 'when there is an array of payments' do
    before :each do
      user = FactoryGirl.create(:payment).registration.user
      user.confirm!
      sign_in user
    end
    it 'should contain a table of payments' do
      render
      rendered.should have_css('table')
    end
  end
end