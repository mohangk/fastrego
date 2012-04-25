class PagesController < ApplicationController
  
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
end
