Rails.application.routes.draw do
  root to: 'categories#index'
  devise_for :users
  resources :categories
  resources :products  do
    member do
      delete  'delete_image/:image_id', to: 'products#delete_image', as: 'delete_image'
    end
  end
end

