class RegistrationsController < ApplicationController
  before_filter :authenticate_user!

  def new 
    redirect_to institutions_path if params[:institution_id].nil? or params[:institution_id].empty?
    @tournament = current_tournament
    @institution = Institution.find_by_id(params[:institution_id])
  end

  def create
    @registration = Registration.new
    @registration.team_manager = current_user
    @registration.institution_id = params[:institution_id]
    @registration.tournament = current_tournament
    if @registration.save
      redirect_to profile_url, notice: "You have been successfully assigned to be the team manager for #{@registration.institution.name} contingent during the #{@registration.tournament.name}."
    else
      redirect_to institutions_path, alert: 'Apologies, you cannot be assigned as the team manager'
    end
  end

  def update
    @registration = Registration.find(params[:id])
    @registration.requested_at = Time.now
    
    if @registration.update_attributes(params[:registration])
      redirect_to profile_url, notice: 'Registration was successful.'
    else
      redirect_to profile_url, notice: 'There was an error while recording your registration.'
    end
  end

end
