Rails.application.routes.draw do
  get 'users/index'
  mount_devise_token_auth_for 'User', at: 'auth',
  controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  jsonapi_resources :addresses
  jsonapi_resources :orders
  jsonapi_resources :categories
  jsonapi_resources :models do
    jsonapi_resources :products
  end
  jsonapi_resources :products do
    patch "image/:image_id", to: "products#update_filename"
    delete "image/:image_id", to: "products#purge_image"

    patch "stock/:stock_id", to: "products#update_stock"
    delete "stock/:stock_id", to: "products#purge_stock"
  end
  jsonapi_resources :users
  resources :payment_intent

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
