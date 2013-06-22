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

    @current_tournaments = {}

    @past_tournaments = {}

    Tournament.order('id desc').all.each do |t|
      if t.active == true
        @current_tournaments[t.name] = t.url
      elsif t.active == false
        @past_tournaments[t.name] = t.url
      end
    end
  end

  def paypal_payment_notice

    @checkout_params = {}

    if !params[:type].nil?
      @checkout_params = { type: params[:type] }
    end

    render :paypal_payment_notice, layout: false
  end
end
