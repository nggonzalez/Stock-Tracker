Rails.application.routes.draw do
  namespace :api, path: '/api' do # constraints: {subdomain: 'api'} do
    #resources :students, only: [:index, :show]
    get '/student', to: 'students#show'
    get '/shares', to: 'shares#show'
    # resources :offers, only: [:index, :create, :update]
    get '/offers', to: 'offers#index'
    post '/offers', to: 'offers#create'
    put '/offers', to: 'offers#update'
    patch '/offers', to: 'offers#update'
    get '/teams', to: 'teams#show'
  end

  root 'main#index'
  post '/logout', to: 'main#logout'

  get '/equity', to: 'main#index'
  get "/*path", to: "main#index", format: false
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
