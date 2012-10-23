require 'spec_helper'

describe PagesController do
  
  describe 'GET embed_logo' do
    it 'should render the embed_logo view' do
      get :embed_logo 
      response.should render_template('embed_logo', 'layout/pages_layout')
    end
  end
  
  describe 'GET enquiry' do
    it 'should render the enquiry view' do
      get :enquiry
      response.should render_template('enquiry', 'layout/pages_layout')
    end
  end

  describe 'GET homepage' do
    it 'should render the homepage view' do
      get :homepage
      response.should render_template('homepage', 'layout/pages_layout')
    end
  end
  

end
