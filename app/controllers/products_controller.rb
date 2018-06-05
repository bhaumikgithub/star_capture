class ProductsController < ApplicationController

  include InheritAction
  before_action :set_product, only: [:update_location, :update_address, :delete_image]

  def delete_image
    @resource.images.where(id: params[:image_id]).purge
    redirect_to product_path(@resource)
  end

  def update_location
    @resource.update(latitude: params[:latitude], longitude: params[:longitude])
    render json: { product: @resource }
  end

  def update_address
    @resource.update(resource_params)
    redirect_to product_path(@resource)
  end

  def show_nearby_products
    @nearby_products = Product.near([current_user.latitude, current_user.longitude], 200,{order: ""}).pluck(:latitude,:longitude)
    @user_location = current_user.reverse_geocode

  end

  def update_user_location
    current_user.update(latitude: params[:latitude], longitude: params[:longitude])
    @user_location = current_user.reverse_geocode
    sleep 3
    render json: {city: @user_location.city, country: @user_location.country, state: @user_location.state, pincode: @user_location.postal_code, address: @user_location.address}
  end

  private

  def resource_params
    params.require(:product).permit(:name, :price, :city, :state, :country, :pincode, :address, :images => [], :category_ids => [])
  end

  def set_product
    @resource = Product.find_by(id: params[:id])
  end
end
