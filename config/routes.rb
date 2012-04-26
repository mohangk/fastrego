UadcRego::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  resources :institutions, only: [:new, :create, :index]
  match "profile" => "users#show", as: :profile, via: :get
  match "embed_logo" => "pages#embed_logo", as: :embed_logo, via: :get
  match 'enquiry' => 'pages#enquiry', as: :enquiry, via: :get
  match 'enquiry' => 'pages#send_enquiry', as: :enquiry, via: :post
  match "users/registration" => "users#registration", via: :post
  match "users/debaters" => "users#edit_debaters", via: :get
  match "users/debaters" => "users#update_debaters", via: :put
  match "users/adjudicators" => "users#edit_adjudicators", via: :get
  match "users/adjudicators" => "users#update_adjudicators", via: :put
  match "users/observers" => "users#edit_observers", via: :get
  match "users/observers" => "users#update_observers", via: :put
  match "users/payments" => "users#payments", via: :post
  match "users/payments/:id" => "users#destroy_payments", via: :delete, as: 'delete_payments'
  match "users/registration" => redirect('/profile'), via: :get
  match "users/payments" => redirect('/profile'), via: :get
  root :to => "users#show"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
