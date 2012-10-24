require 'spec_helper'

describe UsersController do

  before(:each) do
    user.confirm!
    sign_in user
  end

end
