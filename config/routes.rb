# frozen_string_literal: true

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
  resources :itineraries do
    collection do
      get :itinerary_products
      post :create_itinerary_products
      get :get_itinerary_schedule
      get :check_itinerary_products
      patch :update_itinerary_product_description
      patch :update_intinerary_products
      patch :update_itinerary_product_schedule
    end
    member do
      delete :delete_itinerary_schedule
      delete :delete_itinerary_products
      get :add_new_schedule_itinerary
      get :add_itinerary_traveller
      post :create_itinerary_traveller
      get :view_itinerary_details
      delete :delete_itinerary_client
    end
  end
  resources :category_templates
  resources :product_types
  # resources :itinerary_schedules
  resources :rater, only: [:update]
  resources :transport_types
  scope "/operator" do
    resources :users do
      member do
        post :create_travellers
      end
    end
  end
  resources :schedules
end

