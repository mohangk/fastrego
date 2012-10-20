class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @registration = current_registration
    @payment = Payment.new
  end

  def edit_debaters
    @registration = current_user.registration
  end

  def update_debaters
    @registration = current_user.registration
    if @registration.update_attributes(params[:registration])
      redirect_to profile_url, notice: 'Debater profiles were updated.'
    else
      render action: 'edit_debaters'
    end
  end

  def edit_adjudicators
    @registration = current_user.registration
    (@registration.adjudicators_confirmed - @registration.adjudicators.count).times { @registration.adjudicators.build }
  end

  def update_adjudicators
    @registration = current_user.registration
    if @registration.update_attributes(params[:registration])
      redirect_to profile_url, notice: 'Adjudicator profiles were updated.'
    else
      render action: 'edit_adjudicators'
    end
  end

  def edit_observers
    @registration = current_user.registration
    (@registration.observers_confirmed - @registration.observers.count).times { @registration.observers.build }
  end

  def update_observers
    @registration = current_user.registration
    if @registration.update_attributes(params[:registration])
      redirect_to profile_url, notice: 'Observer profiles were updated.'
    else
      render action: 'edit_observers'
    end
  end


end
