require 'spec_helper'

describe 'AdminInstitution' do
  let!(:t2) { FactoryGirl.create(:t2_tournament) }
  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:t1_team_manager) { FactoryGirl.create(:user, email: 't1_team_manager@test.com') }
  let!(:t2_team_manager) { FactoryGirl.create(:user, email: 't2_team_manager@test.com') }
  let!(:t1_registration) { FactoryGirl.create(:registration, tournament: t1, team_manager: t1_team_manager) }
  let!(:t2_registration) { FactoryGirl.create(:registration, tournament: t2, team_manager: t2_team_manager) }

  pending 'only lists team managers who have submitted payments in the select'
  pending 'only list institutions that have submitted payments in the select'
  pending 'only proof of payments relevant to the team manager are available'

  before :each do
    login_for_tournament(t2)
  end

  describe 'payments index' do

    let!(:manual_payment) { FactoryGirl.create :completed_manual_payment, registration: t2_registration }
    let!(:paypal_payment) { FactoryGirl.create :paypal_payment, registration: t2_registration }
    let!(:payments) {[manual_payment, paypal_payment]}

    before :each do
      visit admin_payments_path
    end

    it 'lists the payments' do

      payment_list = AdminPaymentListPage.new
      payment_list.should have(payments.count).data_rows

      data_rows = payment_list.data_rows

      data_rows[0].should have_action 'Show'
      data_rows[0].should have_action 'Edit'
      data_rows[0].should have_action 'Proof'
      data_rows[0].should have_action 'Delete'

      data_rows[1].should have_action 'Show'
      data_rows[1].should_not have_action 'Edit'
      data_rows[1].should_not have_action 'Proof'
      data_rows[1].should_not have_action 'Delete'
    end

    it 'show the manual payment details' do

      payment_list = AdminListPage.new
      data_rows = payment_list.data_rows

      manual_payment_show_page = data_rows[0].click_show
      manual_payment_show_page.should have_content manual_payment.id
      manual_payment_show_page.should have_content manual_payment.type
      manual_payment_show_page.should have_content manual_payment.status
      manual_payment_show_page.should have_content manual_payment.date_sent.strftime('%B %d, %Y')
      manual_payment_show_page.should have_content manual_payment.amount_sent
      manual_payment_show_page.should have_content manual_payment.account_number
      manual_payment_show_page.should have_content manual_payment.comments
      manual_payment_show_page.should have_content manual_payment.amount_received
      manual_payment_show_page.should have_content manual_payment.admin_comment
    end

    it 'shows the paypal payment details' do

      payment_list = AdminListPage.new
      data_rows = payment_list.data_rows

      paypal_payment_show_page = data_rows[1].click_show
      paypal_payment_show_page.should have_content paypal_payment.id
      paypal_payment_show_page.should have_content paypal_payment.type
      paypal_payment_show_page.should have_content paypal_payment.status
      paypal_payment_show_page.should have_content paypal_payment.date_sent.strftime '%B %d, %Y'
      paypal_payment_show_page.should have_content paypal_payment.amount_sent
      paypal_payment_show_page.should have_content paypal_payment.admin_comment
    end

  end

  describe 'create and update payments' do
    pending 'form only lists institutions who have registrations for this tournament'

    before :each do
      visit admin_payments_path
    end

    it 'allows for a manual payment to be created and edited and deleted' do
      registration = t2_registration

      payment_list = AdminPaymentListPage.new
      payment_list.should have_content 'Payment'
      admin_payment_form = payment_list.click_new
      admin_payment_form.create registration.institution.name

      visit admin_payments_path
      payment_list = AdminPaymentListPage.new
      payment_list.should have(1).data_rows
      data_rows = payment_list.data_rows
      data_rows[0].columns[1].text().should == registration.institution.abbreviation
      admin_payment_form = data_rows[0].click_edit
      admin_payment_form.verify_create registration.institution.abbreviation

      admin_payment_form.update
      visit admin_payments_path

      payment_list = AdminPaymentListPage.new
      payment_list.data_rows[0].columns[8].text().should == '110.00'

      payment_list = payment_list.data_rows[0].click_delete
      payment_list.should have(0).data_rows
    end

  end
end

