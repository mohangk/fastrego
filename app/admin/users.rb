ActiveAdmin.register User do
  index do
    column :id
    column :name
    column :email
    column :institution
    column :phone_number
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    column :updated_at
    default_actions
  end
  
end
