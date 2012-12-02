require 'spec_helper'

describe 'AdminInstitution' do

  let!(:institution) { FactoryGirl.create(:institution) }
  let!(:t1) { FactoryGirl.create(:t1_tournament) }

  describe 'all institutions' do
    it 'can only be listed and viewed' do

      login_for_tournament(t1)
      visit admin_institutions_path
      page.should have_content 'Institution'
      page.should_not have_content 'New'
      page.should_not have_content 'Edit'
      page.should_not have_content 'Delete'
      click_link 'View'
      page.should have_content institution.name
    end
  end
end

