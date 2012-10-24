class GenericPage 
  include Capybara::DSL
  include Capybara::Node::Matchers
  include RSpec::Matchers
  include Rails.application.routes.url_helpers

  attr_accessor :url

  def html
    page.html
  end

  def correct_page?
    page.should have_css self.class::ELEMENTS['page check element']
  end

  def elements_exists?(selement)
    page.has_selector? self.class::ELEMENTS[element]
  end

  def current_url
    page.current_url
  end
end
