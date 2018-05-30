Rails.application.routes.draw do
  root to: 'categories#index'
  devise_for :users
  resources :categories
  resources :products
end

