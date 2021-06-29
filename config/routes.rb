Rails.application.routes.draw do
  resources :addresses
  get 'users/index'
  mount_devise_token_auth_for 'User', at: 'auth',
  controllers: {
    registrations: 'users/registrations'
  }
  resources :orders
  resources :categories
  resources :models do
    resources :products
  end
  resources :products do
    patch "image/:image_id", to: "products#update_filename"
    delete "image/:image_id", to: "products#purge_image"

    patch "stock/:stock_id", to: "products#update_stock"
    delete "stock/:stock_id", to: "products#purge_stock"
  end
  resources :users

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
