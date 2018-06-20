Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  root to: 'categories#index'
  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
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
      post :create_product_comments
      get :load_more_comments
      put "like", to: "products#liked_by_user"
      delete :delete_product_comment
    end
    collection do
      get :show_nearby_products
      patch :update_user_location
    end
  end
  resources :category_templates
  resources :product_types
  resources :rater, only: [:update]
end

