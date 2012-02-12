ActiveAdmin.register User do

  scope :joined, :default => true do |users|
    users.includes [:institution]
  end

  index do
    column :id
    column :name
    column :email
    column :institution, :sortable => :'institutions.name'
    column :phone_number
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    column :updated_at
    default_actions
  end

end
