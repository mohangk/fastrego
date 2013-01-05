class PaymentsController < ApplicationController
  before_filter :authenticate_user!, except: :ipn
  include ActiveMerchant::Billing::Integrations

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

  def checkout
    recipients = [{:email => 'fastre_1356344930_biz@gmail.com',
                   :amount => 1000,
                   :primary => true},
                  {:email => 'mohang_1356050668_biz@gmail.com',
                   :amount => 900,
                   :primary => false}
                   ]
    response = GATEWAY.setup_purchase(
      :return_url => url_for(:action => 'completed', :only_path => false),
      :cancel_url => url_for(:action => 'canceled', :only_path => false),
      :ipn_notification_url => url_for(:action => 'ipn', :only_path => false),
      :receiver_list => recipients
    )

    # For redirecting the customer to the actual paypal site to finish the payment.
    redirect_to (GATEWAY.redirect_url_for(response["payKey"]))
  end

  def completed
    render text: 'Completed payment'
  end

  def canceled
    render text: 'Cancel payment'
  end
  
  def ipn
    notify = Paypal::Notification.new(request.raw_post)
    
    if notify.masspay?
      masspay_items = notify.items
    end
    
    #order = Order.find(notify.item_id)
    
    logger.error "==> Notify item_id #{notify.item_id}"

    if notify.acknowledge 
      begin
        
        if notify.complete? #and order.total == notify.amount
          logger.error "Notify amount #{notify.amount}"
          logger.error "Status: #{notify.complete?}"
          #order.status = 'success' 
          
          #shop.ship(order)
        else
          logger.error("Failed to verify Paypal's notification, please investigate")
        end
    
      rescue => e
        logger.error "FAILED : #{notify.complete?}"
        #order.status = 'failed'      
        raise
      ensure
        order.save
      end
    end
    
    render :nothing
  end

end
