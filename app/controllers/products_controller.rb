# frozen_string_literal: true

class ProductsController < ApplicationController

  load_and_authorize_resource

  include InheritAction
  before_action :set_product, only: [:update_location, :update_address, :delete_image,:create_product_comments, :load_more_comments, :liked_by_user, :delete_product_comment]

  def new
    @resource = Product.new
    if params[:category_id]
      @template = Category.find_by(id: params[:category_id]).category_template
    else
      @template = Category.first.category_template
    end
  end

  def create
    params[:product][:timings] =  params[:product][:timings].to_h.each { |k,v|  v.delete_if {|key, value| value.empty? && value.empty? }    }.delete_if {|k,v| v.empty?}
    if params[:category_id]
      @template = Category.find_by(id: params[:category_id]).category_template
    elsif params[:product][:category_ids]
        @template = Category.find_by(id: params[:product][:category_ids]).category_template
    else
      @template = Category.first.category_template
    end
    super
  end

  def edit
    if params[:category_id]
      @template = Category.find_by(id: params[:category_id]).category_template
    else
      @template = @resource.categories.last.category_template
    end
  end

  def update
    if params[:product]['timings'].present?
      params[:product][:timings] =  params[:product][:timings].permit!.to_h.each { |k,v|  v.delete_if {|key, value| value.empty? && value.empty? }    }.delete_if {|k,v| v.empty?}
    end
    super
  end

  def index
    if current_user.admin?
      if params[:category_id].present?
        @resources = Category.find_by(id: params[:category_id]).products.includes(:categories).order('created_at DESC').page(params[:page]).per(10)
        @category_id = params[:category_id]
      else
        @resources = Product.includes(:categories).order('created_at DESC').page(params[:page]).per(10)
      end
    else
      if params[:category_id].present?
        @resources = Category.find_by(id: params[:category_id]).products.includes(:categories).near([current_user.latitude, current_user.longitude], 5).page(params[:page]).per(10)
        @category_id = params[:category_id]
      else
        @resources = Product.includes(:categories).near([current_user.latitude, current_user.longitude], 5).page(params[:page]).per(10)
      end
    end
  end

  def show
    super
    @template = @resource.categories.first.category_template
    @rate = Rate.find_by(rater_id: current_user.id, rateable_id: params[:id])
    @rates = Rate.where(rateable_id: params[:id]).where.not(comment: nil).order('created_at DESC')
    @comments = @resource.product_comments.order(created_at: :desc).limit(10)
    @comment_count = @resource.comment_count
  end

  def delete_image
    @resource.multiple_images.where(id: params[:image_id]).purge
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
    index()
    @itinerary_schedule_id = params[:itinerary_schedule_id] if params[:itinerary_schedule_id].present?
    @nearby_products = Product.eager_load(:categories).near([current_user.latitude, current_user.longitude], 5,{order: ""}).pluck(:latitude,:longitude,:id,:name,:price, :"categories.name")
    @product_categories = @nearby_products.each_with_object({ }) do |item, result|
      item[4] = item[4]  ? item[4] : 0
      (result[item[2]] ||= [ ]) << item[5]
    end
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

  
  #product comments methods start
  def create_product_comments
    current_user.product_comments.create(comment:params[:comment],product_id:params[:id])
    @comments = @resource.product_comments.order(created_at: :desc).limit(10)
    @comment_count = @resource.comment_count
    respond_to do |format|
      format.js {render 'load_comments.js.erb'}
    end
  end

  def load_more_comments
    @all = false
    @comments = @resource.product_comments.order(created_at: :desc).limit(params[:count])
    @comment_count = @resource.comment_count
    if @comment_count == @comments.count
      @all = true
    end
    respond_to do |format|
      format.js {render  'load_comments.js.erb'}
    end
  end

  def delete_product_comment
    ProductComment.find(params[:comment_id]).destroy
    @comments = @resource.product_comments.order(created_at: :desc).limit(10)
    @comment_count = @resource.comment_count
    respond_to do |format|
      format.js {render  'load_comments.js.erb'}
    end
  end
  # product comments methods end

  #like
  def liked_by_user
    @resource.liked_by current_user
  end

  private

  def resource_params
    params.require(:product).permit!
  end

  def set_product
    @resource = Product.find_by(id: params[:id])
  end
end
