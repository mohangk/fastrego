ActiveAdmin.register Payment do
  scope :all, :default => true do |p|
    p.includes [ :registration => { :user => :institution } ]
  end
  config.sort_order = "instituion.id desc , payments.id desc"

  index do
    column 'Inst' do |p|
      link_to p.registration.user.institution.abbreviation, admin_institution_path(p.registration.user.institution)
    end
    column 'Date', :date_sent
    column 'Amount sent' do |p|
      number_to_currency p.amount_sent, unit: 'RM'    end
    column 'A/C #', :account_number
    column 'Comments', :comments
    column 'Proof'  do |p|
      link_to 'View', p.scanned_proof.url
    end
    column :created_at
    column 'Amount received' do |p|
        number_to_currency p.amount_received, unit: 'RM'
    end
    column 'Admin comment', :admin_comment
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :institution_name , :input_html => { :disabled => true }
      f.input :date_sent, :input_html => { :disabled => true }
      f.input :amount_sent, :input_html => { :disabled => true }
      f.input :account_number, :input_html => { :disabled => true }
      f.input :comments, :input_html => { :disabled => true }
      f.input :created_at, :input_html => { :disabled => true }
      f.input :amount_received, as: :string
      f.input :admin_comment
      f.buttons
    end
  end

  controller do
    def update
      @payment = Payment.find(params[:id])
      @payment.amount_received = params[:payment][:amount_received]
      @payment.admin_comment = params[:payment][:admin_comment]

      if @payment.save
        redirect_to admin_payments_path, notice: 'Payment was successfully updated.'
      else
        render action: "edit"
      end
    end
  end
  
end
