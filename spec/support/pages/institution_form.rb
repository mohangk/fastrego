class InstitutionForm < GenericPage

  def correct_page?
    page.should have_css ''
  end

  def fill_details options = {}

    fill_in 'Name', with: options[:name] || 'Universiti Teknologi Malaysia'
    fill_in 'Abbreviation', with: options[:abbreviation] || 'UTM'
    fill_in 'Website', with: options[:website] || 'http://www.utm.com'
    choose options[:type] || 'University'
    select options[:country] || 'Malaysia', from: 'Country'
    click_button 'Save'

    page.should have_content('successfully registered')
    page.current_path.should == institutions_path

    InstitutionsPage.new
  end

end
