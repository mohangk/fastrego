class InstitutionForm < GenericPage

  def correct_page?
    page.should have_css ''
  end

  def fill_details options = {}

    fill_in 'Name', with: 'Universiti Teknologi Malaysia'
    fill_in 'Abbreviation', with: 'UTM'
    fill_in 'Website', with: 'http://www.utm.com'
#      select 'University', from: 'Type'
    select 'Malaysia', from: 'Country'
    click_button 'Save'
    page.should have_content('successfully registered')
    page.current_path.should == institutions_path
    InstitutionsPage.new
  end

end
