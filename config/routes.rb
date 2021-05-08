Rails.application.routes.draw do
  get 'users/index'
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :orders
  resources :categories
  resources :models
  resources :products
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
