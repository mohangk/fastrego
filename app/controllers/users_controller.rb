class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @registration = Registration.new
  end

  def registration
    @registration = Registration.new(params[:registration])
    @registration.user = current_user

    if @registration.save
      redirect_to profile_url, notice: 'Registration was successful.'
    else
      render action: "show"
    end
  end
end
