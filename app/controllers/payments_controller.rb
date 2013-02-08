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
    payment = ManualPayment.find(params[:id])

    if !payment.nil? and payment.destroyable?(current_user)
      payment.destroy
      redirect_to profile_url, notice: 'Payment was removed.'
    else
      redirect_to profile_url, alert: 'Unauthorised access.'
    end
  end

  def checkout
    begin
      @paypal_payment = PaypalPayment.create current_registration

      response = GATEWAY.setup_purchase(
        :fees_payer =>           'PRIMARYRECEIVER',
        :return_url =>           completed_payment_path(only_path: false, id: @paypal_payment.id),
        :cancel_url =>           canceled_payment_path(only_path: false, id: @paypal_payment.id),
        :ipn_notification_url => url_for(:action => 'ipn', :only_path => false),
        :receiver_list =>        current_registration.paypal_recipients
      )

      logger.info "PAYPAL Setup purchase request'#{response.request.inspect}'"
      logger.info "PAYPAL Setup purchase response'#{response.json.inspect}'"

      if response.success?
        @paypal_payment.update_pay_key(response["payKey"])
        redirect_to (GATEWAY.redirect_url_for(response["payKey"]))
      else
        raise 'Setup purchase response from Paypal failed'
      end

    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace

      @payment = ManualPayment.new
      @paypal_payment.errors[:base] << "Paypal Payment error #{e.message}"
      @registration = current_registration
      render 'users/show' and return
    end

  end

  def completed
    @paypal_payment = PaypalPayment.find(params[:id])
    abort_if_not_owner(@paypal_payment) and return
    render 'users/completed'
  end

  def canceled
    @paypal_payment = PaypalPayment.find(params[:id])
    abort_if_not_owner(@paypal_payment) and return
    @paypal_payment.cancel!
    render 'users/canceled'
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
          log_notify notify
          payment.status = PaypalPayment::STATUS_COMPLETED
          payment.amount_received = notify.amount.split[1].to_i
        elsif completeness and notify.amount > 0
          log_notify notify
          payment.status = PaypalPayment::STATUS_COMPLETED
          payment.amount_received = notify.amount
        else
          log_notify notify
          payment.status = PaypalPayment::STATUS_FAIL
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

  private

  def log_notify notify
    logger.error "notify amount #{notify.amount}"
    logger.error "status: #{notify.complete?}"
  end

  def abort_if_not_owner(payment)
    redirect_to profile_url, alert: 'Error' if payment.nil? || !payment.owner?(current_user)
  end

end
