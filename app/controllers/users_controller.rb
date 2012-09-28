class UsersController < ApplicationController
  before_filter :authenticate_user!

  def current_registration
    #current_user.managed_registration.for_tournament(current_subdomain, current_user)
  end

  helper_method :current_registration

  def show
    @registration = current_registration.nil? ? Registration.new : current_registration
    @payment = Payment.new
  end

  def payments
    @payment = Payment.new(params[:payment])
    @payment.registration = current_user.registration
    if @payment.save
      redirect_to profile_url, notice: 'Payment was successfully recorded.'
    else
      render action: 'show'
    end
  end

  def destroy_payments
    payment = Payment.find_by_id(params[:id])
    if !payment.nil? and current_user.registration == payment.registration and not payment.confirmed?
      payment.destroy
      redirect_to profile_url, notice: 'Payment was removed.'
    else
      redirect_to profile_url, alert: 'Unauthorised access.'
    end
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
