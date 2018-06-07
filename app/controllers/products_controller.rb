class ProductsController < ApplicationController

  include InheritAction
  before_action :set_product, only: [:update_location, :update_address, :delete_image]

  def index
    if current_user.admin?
      if params[:category_id].present?
        @resources = Category.find_by(id: params[:category_id]).products.order('created_at DESC').page(params[:page]).per(10)
        @category_id = params[:category_id]
      else
        @resources = Product.order('created_at DESC').page(params[:page]).per(10)
      end
    else
      if params[:category_id].present?
        @resources = Category.find_by(id: params[:category_id]).products.near([current_user.latitude, current_user.longitude], 5).page(params[:page]).per(10)
        @category_id = params[:category_id]
      else
        @resources = Product.near([current_user.latitude, current_user.longitude], 5).page(params[:page]).per(10)
      end
    end
  end

  def delete_image
    @resource.images.where(id: params[:image_id]).purge
    redirect_to product_path(@resource)
  end

  def update_location
    @resource.update(latitude: params[:latitude], longitude: params[:longitude])
    sleep 3
    render json: { product: @resource }
  end

  def update_address
    @resource.update(resource_params)
    redirect_to product_path(@resource)
  end

  def show_nearby_products
    @nearby_products = Product.near([current_user.latitude, current_user.longitude], 5,{order: ""}).pluck(:latitude,:longitude,:id,:name,:price)
    @user_location = current_user.reverse_geocode

  end

  def update_user_location
    if current_user.user?
      is_updated = false
      unless params[:latitude] == current_user.latitude.to_s || params[:longitude] == current_user.longitude.to_s
      current_user.update(latitude: params[:latitude], longitude: params[:longitude])
        is_updated = true
      end
      @user_location = current_user.reverse_geocode
      sleep 4
      render json: {city: @user_location.city, country: @user_location.country, state: @user_location.state, pincode: @user_location.postal_code, address: @user_location.address,is_updated: is_updated}
    end
  end

  private

  def resource_params
    params.require(:product).permit(:name, :price, :city, :state, :country, :pincode, :address, :images => [], :category_ids => [])
  end

  def set_product
    @resource = Product.find_by(id: params[:id])
  end
end
