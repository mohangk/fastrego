class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @registration = Registration.new
  end
end
