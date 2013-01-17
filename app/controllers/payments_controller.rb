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
      logger.info "PAYPAL Setup purchase request'#{response.request.inspect}'"
      logger.info "PAYPAL Setup purchase response'#{response.json.inspect}'"

      @paypal_payment.transaction_txnid = response["payKey"]
      @paypal_payment.primary_receiver = current_registration.paypal_recipients[0][:email]
      @paypal_payment.secondary_receiver = current_registration.paypal_recipients[1][:email]

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
    payment = Payment.where(transaction_txnid: notify.params['pay_key']).first
    acknowledged = notify.acknowledge

    if acknowledged and payment.nil?
      logger.error "MISSING PAYMENT pay_key: '#{notify.params['pay_key']}' complete ?: '#{notify.complete?}', amount: '#{notify.amount}'"
    end
    if acknowledged and !payment.nil?
      begin
        completeness = notify.complete?
        if completeness and payment.amount_sent.to_i == notify.amount.split[1].to_i
          logger.error "notify amount #{notify.amount}"
          logger.error "status: #{notify.complete?}"
          payment.status = 'Success'
          payment.amount_received = notify.amount.split[1].to_i
        elsif completeness and notify.amount > 0 
          logger.error "notify amount #{notify.amount}"
          logger.error "status: #{notify.complete?}"
          payment.status = 'Partial'

          payment.amount_received = notify.amount
        else
          payment.status = 'Fail'
          logger.error("Failed to verify Paypal's notification, please investigate")
        end

      rescue => e
        logger.error "FAILED : #{notify.complete?}"
        payment.status = 'Fail'
        raise
      ensure
        payment.save
      end
    end

    render nothing: true
  end

end
