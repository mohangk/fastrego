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
      'Canton IV 2013' => 'http://cantoniv2013.herokuapp.com',
      'Malaysian Debate Open 2013' => 'http://mdo2013.herokuapp.com',
      'World Debate Forum 2013' => 'http://wdf2013.herokuapp.com'
    }

    @past_tournaments = {
      'Berlin WUDC 2013' => 'http://wudcberlin.herokuapp.com',
      'North East Asians 2012' => nil,
      'MMU UADC 2012'  => nil,
      'BIPEDS Asian BP 2012' => nil, 
      'Summer Asian Debate Institute 2012' => nil,
      '11th Korean National Championships' => nil,
      'Philippine School Debates 2012' => nil
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
