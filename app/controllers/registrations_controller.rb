class RegistrationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @registration = Registration.new
    @registration.team_manager = current_user
    @registration.institution_id = params[:institution_id]
    @registration.tournament = Tournament.find_by_identifier(current_subdomain)
    if @registration.save
      redirect_to profile_url, notice: "You have been successfully assigned to be the team manager for #{@registration.institution.name} contingent during the #{@registration.tournament.name}."
    else
      redirect_to institutions_path, alert: 'Apologies, you cannot be assigned as the team manager'
    end
  end
end
