ActiveAdmin.register Payment do
  scope :all, :default => true do |p|
    p.includes [ :registration => { :user => :institution } ]
  end
  config.sort_order = "instituion.id desc , payments.id desc"

  index do
    column 'Inst', sortable: 'institutions.abbreviation' do |p|
      link_to p.registration.user.institution.abbreviation, admin_institution_path(p.registration.user.institution)
    end
    column 'Date', :date_sent
    column 'Amount sent' do |p|
      number_to_currency p.amount_sent, unit: (Setting.table_exists? ? Setting.key('currency_symbol') : 'RM')
    end
    column 'A/C #', :account_number
    column 'Comments', :comments
    column 'Proof'  do |p|
      link_to 'View', p.scanned_proof.url
    end
    column :created_at
    column 'Amount received' do |p|
        number_to_currency p.amount_received, unit: (Setting.table_exists? ? Setting.key('currency_symbol') : 'RM')    end
    column 'Admin comment', :admin_comment
    default_actions
  end

  form do |f|
    f.inputs do
      disable_field = true unless f.object.new_record?
      f.input :registration_id, label: 'Institution', as: :select, collection: Hash[Registration.all.map{ |r| [r.institution_name,r.id]}],:input_html => { :disabled => disable_field }
      f.input :date_sent, :input_html => { :disabled => disable_field }
      f.input :amount_sent, as: :string, :input_html => { :disabled => disable_field }
      f.input :account_number, :input_html => { :disabled => disable_field }
      f.input :scanned_proof
      f.input :comments, :input_html => { :disabled => disable_field }
      if !f.object.new_record?
        f.input :created_at, :input_html => { :disabled => true }
      end 
      f.input :amount_received, as: :string
      f.input :admin_comment
      f.buttons
    end
  end

  controller do
    def create
      @payment = Payment.new(params[:payment])
      @payment.registration_id = params[:payment][:registration_id]
      @payment.amount_received = params[:payment][:amount_received]
      @payment.admin_comment = params[:payment][:admin_comment]
      if @payment.save
        @payment.send_payment_notification
        redirect_to admin_payments_path, notice: 'Payment was successfully updated.'
      else
        render action: "edit"
      end
    end

    def update
      @payment = Payment.find(params[:id])
      @payment.amount_received = params[:payment][:amount_received]
      @payment.admin_comment = params[:payment][:admin_comment]

      if @payment.save
        @payment.send_payment_notification
        redirect_to admin_payments_path, notice: 'Payment was successfully updated.'
      else
        render action: "edit"
      end
    end
  end

  filter :registration_user_name, as: :select, collection: proc { User.order(:name).all.map(&:name) }
  filter :registration_user_institution_name, as: :select, collection: proc {Institution.order(:name).all.map(&:name)}
  filter :date_sent
  filter :amount_sent
  filter :comments
  filter :amount_received
  filter :admin_comment
end
