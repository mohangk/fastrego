class PaymentsController < ApplicationController
  before_filter :authenticate_user!, except: :ipn
  skip_before_filter :verify_authenticity_token, :only => [:ipn]
  include ActiveMerchant::Billing::Integrations

  def create
    @payment = ManualPayment.new(params[:payment])
    @payment.registration = current_registration
    if @payment.save
      redirect_to profile_url, notice: 'ManualPayment was successfully recorded.'
    else
      @registration = current_registration
      render 'users/show'
    end
  end

  def destroy
    payment = ManualPayment.find_by_id(params[:id])
    if !payment.nil? and payment.destroyable?(current_user)
      payment.destroy
      redirect_to profile_url, notice: 'ManualPayment was removed.'
    else
      redirect_to profile_url, alert: 'Unauthorised access.'
    end
  end

  def checkout

    @paypal_payment = PaypalPayment.new({:registration => current_registration,
                                         :date_sent => Date.today,
                                         :amount_sent => current_registration.balance_fees})

    begin
      response = GATEWAY.setup_purchase(
        :return_url => url_for(:action => 'completed', :only_path => false),
        :cancel_url => url_for(:action => 'canceled', :only_path => false),
        :ipn_notification_url => url_for(:action => 'ipn', :only_path => false),
        :receiver_list => current_registration.paypal_recipients
      )
    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace

      @payment = ManualPayment.new
      @paypal_payment.errors[:base] << "Paypal Payment error #{e.message}"
      @registration = current_registration

      render 'users/show' and return
    end

    if @paypal_payment.save
      redirect_to (GATEWAY.redirect_url_for(response["payKey"]))
    else
      @payment = ManualPayment.new
      @registration = current_registration
      render 'users/show'
    end
    # For redirecting the customer to the actual paypal site to finish the payment.
  end

  def completed
    render text: 'Completed payment'
  end

  def canceled
    render text: 'Cancel payment'
  end

  def ipn
    notify = PaypalAdaptivePayment::Notification.new(request.raw_post)

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
        #order.save
      end
    end

    render nothing: true
  end

end
