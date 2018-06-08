Rails.application.routes.draw do
  root to: 'categories#index'
  devise_for :users, controllers: {
        sessions: 'users/sessions'
      }
  resources :categories do
    member do
      delete :delete_category_with_products
    end
  end
  resources :products  do
    member do
      delete 'delete_image/:image_id', to: 'products#delete_image', as: 'delete_image'
      patch :update_location
      patch :update_address
    end
    collection do
      get :show_nearby_products
      patch :update_user_location
    end
  end
  resources :templates
end

