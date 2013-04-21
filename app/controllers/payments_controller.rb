class PaymentsController < ApplicationController
  before_filter :authenticate_user!, except: :ipn
  skip_before_filter :verify_authenticity_token, :only => [:ipn]
  include ActiveMerchant::Billing::Integrations

  def show
    @paypal_payment = Payment.find(params[:id])

    abort_if_not_owner(@paypal_payment) and return

    respond_to do |format|
      format.json { render json: @paypal_payment }
    end
  end

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

    if params[:type] == 'pre_registration'
      pre_registration_payment = true
    else
      pre_registration_payment = false
    end

    @paypal_payment = PaypalPayment.generate current_registration, pre_registration_payment
    paypal_request = PaypalRequest.new payment: @paypal_payment,
                                      logger: logger

      setup_payment_options = [
        completed_payment_url(@paypal_payment.id),
        canceled_payment_url(@paypal_payment.id),
        request
      ]

    redirect_to paypal_request.setup_payment *setup_payment_options

    rescue Exception => e
      logger.error e.message
      logger.error e.backtrace

      @payment = ManualPayment.new
      @paypal_payment.errors[:base] << "Paypal Payment error #{e.message}"
      @registration = current_registration
      render 'users/show' and return
  end

  def completed
    @paypal_payment = PaypalPayment.find(params[:id])

    #handle express checkout
    if params[:token] && params[:PayerID]

      paypal_request = PaypalRequest.new payment: @paypal_payment,
                                      logger: logger
      paypal_request.complete_payment params[:token], params[:PayerID]
    end

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
        payment.status = PaypalPayment::STATUS_FAIL
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
