class InstitutionsPage < GenericPage

  ADD_INSTITUTION_LINK = 'Click here to add your institution now' 
  
  def visit
    Capybara::visit institutions_path
  end

  def add_institution
    click_link ADD_INSTITUTION_LINK
    page.should have_content('Add your institution')
    InstitutionForm.new
  end

  def add_team_manager institution
    click_link "add_team_manager_institution_#{institution.id}"
  end

  def has_add_institution_link?
    page.has_link? ADD_INSTITUTION_LINK
  end

  def institution_count
    all('tr').length - 1 
  end


  def has_institution? institution 
    page.has_content?(institution.name) &&
    page.has_content?(institution.abbreviation) &&
    page.has_content?(institution.country) &&
    page.has_content?(institution.website)
  end

  def has_team_manager? institution, team_manager_name = nil
    has_add_team_manager_link = page.has_css?("a[href='/registration/new?institution_id=#{institution.id}']")
    return false if has_add_team_manager_link
    return true if team_manager_name.nil?

    if page.has_content?(team_manager_name)
      true
    else
      false
    end

  end

end

