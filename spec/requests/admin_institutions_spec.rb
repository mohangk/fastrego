require 'spec_helper'

describe 'AdminInstitution' do

  let!(:institution) { FactoryGirl.create(:institution) }
  let!(:t1) { FactoryGirl.create(:t1_tournament) }
  let!(:t2) { FactoryGirl.create(:t2_tournament) }

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

    context 'open institutions' do
      it 'only lists those that are assigned to this tournament' do
        FactoryGirl.create :open_institution, name: 'T1 Open Institution', tournament: t1

        FactoryGirl.create :open_institution, name: 'T2 Open Institution', abbreviation: 't2oi', tournament: t2

        login_for_tournament(t1)
        visit admin_institutions_path
        page.should have_content 'T1 Open Institution'
        page.should_not have_content 'T2 Open Institution'

        login_for_tournament(t2)
        visit admin_institutions_path
        page.should have_content 'T2 Open Institution'
        page.should_not have_content 'T1 Open Institution'
      end
    end
  end
end

