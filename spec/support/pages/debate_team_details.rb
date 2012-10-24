class DebateTeamDetails < GenericPage
  def correct_page?
    page.should have_css 'input[type="text"][name="registration[debaters_attributes][0][name]"]'
  end
end
