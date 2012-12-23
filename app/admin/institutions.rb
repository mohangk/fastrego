ActiveAdmin.register Institution do
  actions :show, :index

  scope_to association_method: :call do 
    lambda { Institution.alphabetically.for_tournament current_subdomain }
  end

  config.sort_order = "name_asc"
end
