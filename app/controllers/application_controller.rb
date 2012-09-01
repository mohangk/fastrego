class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_current_subdomain

  def set_current_subdomain
    Thread.current[:current_subdomain] = request.subdomain 
  end

  def current_subdomain
    Thread.current[:current_subdomain]
  end
  helper_method :current_subdomain

end
