class PagesController < ApplicationController
  layout 'pages_layout'
  
  def embed_logo
  end

  def enquiry
    @enquiry = Enquiry.new
  end

  def send_enquiry 
    @enquiry = Enquiry.new(params[:enquiry])
    if @enquiry.valid?
      EnquiryMailer.send_enquiry(@enquiry).deliver
      flash[:notice] = 'Message sent! Thank you for contacting us.'
      redirect_to enquiry_url
    else
      render action: 'enquiry'
    end
  end

  def homepage

    @current_tournaments = { 
      'Berlin WUDC 2013' => 'http://wudcberlin.herokuapp.com',
      'North East Asians 2012' => 'http://neao2012.herokuapp.com'
    }

    @past_tournaments = {
      'MMU UADC 2012'  => 'http://uadc2012.herokuapp.com',
      'BIPEDS Asian BP 2012' => 'http://bipedsabp.herokuapp.com',
      'Summer Asian Debate Institute 2012' => 'http://asiandebateinstitute.herokuapp.com',
      '11th Korean National Championships' => 'http://solbridgeknc.herokuapp.com',
      'Philippine School Debates 2012' => 'http://psdc2012.herokuapp.com' 
    }

    Tournament.all.each do |t|
      if t.active == true
        @current_tournaments[t.name] = t.url    
      elsif t.active == false
        @past_tournaments[t.name] = t.url    
      end
    end
  end
end
