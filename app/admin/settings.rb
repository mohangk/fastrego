ActiveAdmin.register Setting do
  actions :edit, :update, :index

  scope_to association_method: :call do
    lambda { Setting.for_tournament(current_subdomain, current_admin_user) }
  end

  index do 
    column :key do |r|
      r.key.humanize
    end
    column :value
    default_actions
  end

  csv do
    column :key
    column :value
  end

  form do |f|
    f.inputs "#{f.object.key.humanize}" do
      f.input :value
    end
    f.actions
  end

  controller do 
    def update
      @setting = Setting.find(params[:id])
      @setting.value = params[:setting][:value]
      @setting.tournament = Tournament.find_by_identifier(current_subdomain) 

      if @setting.save
        redirect_to admin_settings_path, notice: 'Setting was successfully updated'
      else
        render action: "edit"
      end
    end
  end

  filter :key
  filter :value
end
