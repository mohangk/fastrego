require 'spec_helper'

describe PagesController do
  
  describe 'GET embed_logo' do
    it 'should render the embed_logo view' do
      get :embed_logo 
      response.should render_template('embed_logo')
    end
  end
  
  describe 'GET enquiry' do
    it 'should render the enquiry view' do
      get :enquiry
      response.should render_template('enquiry')
    end
  end
  

end
