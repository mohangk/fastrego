class PaymentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @payment = Payment.new(params[:payment])
    @payment.registration = current_registration
    if @payment.save
      redirect_to profile_url, notice: 'Payment was successfully recorded.'
    else
      @registration = current_registration
      render 'users/show'
    end
  end


  def destroy
    payment = Payment.find_by_id(params[:id])
    if !payment.nil? and payment.destroyable?(current_user)
      payment.destroy
      redirect_to profile_url, notice: 'Payment was removed.'
    else
      redirect_to profile_url, alert: 'Unauthorised access.'
    end
  end

end
