class AdminPaymentListRow < AdminListRow

  def click_edit
    click_action 'Edit'
    AdminManualPaymentForm.new
  end

  def click_delete
    click_action 'Delete'
    AdminPaymentListPage.new
  end

end

class AdminPaymentListPage < AdminListPage

  @@row_class = AdminPaymentListRow

  def click_new
    page.click_link 'New Payment'
    AdminManualPaymentForm.new
  end

end


class AdminManualPaymentForm < GenericPage

  def create institution_name
    select institution_name, from: 'Institution'

    fill_in 'Amount sent', with: '120'
    fill_in 'Ref #', with: '987654321'
    attach_file 'Proof of transfer', File.join(Rails.root, 'spec', 'uploaded_files', 'test_image.jpg')
    fill_in 'Amount received', with: '100'
    click_button 'Create Payment'
    GenericPage.new
  end

  def verify_create institution_name
    page.should have_select 'Institution', with: institution_name
    page.should have_field 'Amount sent', with: '120.00'
    page.should have_field 'Ref #', with: '987654321'
    page.should have_field 'Amount received', with: '100.00'
  end

  def update
    fill_in 'Amount received' , with: '110.00'
    click_button 'Update Payment'
    GenericPage.new
  end

end
