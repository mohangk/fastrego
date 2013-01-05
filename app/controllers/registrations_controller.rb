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
      redirect_to profile_url
    else
      redirect_to institutions_path, alert: 'Apologies, you cannot be assigned as the team manager'
    end
  end

  def update
    @registration = current_registration
    if @registration.draft? and params[:registration] and @registration.request_slots(params[:registration][:debate_teams_requested], params[:registration][:adjudicators_requested], params[:registration][:observers_requested])
      redirect_to profile_url, notice: 'You have successfully requested teams!'
    else
      redirect_to profile_url, notice: 'There was an error while recording your request.'
    end
  end

  def edit_debaters
    @registration = current_registration
  end

  def update_debaters
    @registration = current_registration
    if @registration.update_attributes(params[:registration])
      redirect_to profile_url, notice: 'Debater profiles were updated.'
    else
      render action: 'edit_debaters'
    end
  end

  def edit_adjudicators
    @registration = current_registration
    (@registration.adjudicators_confirmed - @registration.adjudicators.count).times { @registration.adjudicators.build }
  end

  def update_adjudicators
    @registration = current_registration
    if @registration.update_attributes(params[:registration])
      redirect_to profile_url, notice: 'Adjudicator profiles were updated.'
    else
      render action: 'edit_adjudicators'
    end
  end

  def edit_observers
    @registration = current_registration
    (@registration.observers_confirmed - @registration.observers.count).times { @registration.observers.build }
  end

  def update_observers
    @registration = current_registration
    if @registration.update_attributes(params[:registration])
      redirect_to profile_url, notice: 'Observer profiles were updated.'
    else
      render action: 'edit_observers'
    end
  end


end
