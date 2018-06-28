# frozen_string_literal: true

class ItinerariesController < ApplicationController

  include InheritAction
  before_action :set_itinerary, only: [:delete_itinerary_products, :delete_itinerary_schedule, :add_new_schedule_itinerary,:add_itinerary_traveller, :create_itinerary_traveller, :view_itinerary_details]

  def create
    @resource = current_user.itineraries.new(resource_params)

    if @resource.save
      if @resource.duration_type == 'Days'
        @resource.duration.to_i.times do 
          @resource.itinerary_schedules.create!
        end
      else
        @resource.itinerary_schedules.create!
      end
      redirect_to @resource
    else
      render 'new'
    end
  end

  def itinerary_products
    @products = params["product"]
    @itinerary_schedule = ItinerarySchedule.find_by_id(params[:itinerary_schedule_id])
    @itineraries = Itinerary.all
  end
  
  def get_itinerary_schedule
    itinerary = Itinerary.find_by_id(params[:itinerary])
    render json: { itinerary_schedules: itinerary.itinerary_schedules }
  end

  def check_itinerary_products
    products = params[:products].split(",")
    itinerary_product = ItineraryProduct.joins(:product).where(itinerary_schedule_id:params[:itinerary_schedule_id]).where("product_id IN (?)",products).select("products.name as product_name").map(&:attributes).uniq
    product_names = itinerary_product.map { |h| h["product_name"] }
    render json: { product_names: product_names }
  end

  def create_itinerary_products
    itinerary_schedule =  ItinerarySchedule.find_by(id:params[:itinerary_schedule_id])
    product_array = params[:product_id].split(' ')
    product_array.map { |product| ItineraryProduct.create(product_id: product, itinerary_schedule_id: itinerary_schedule.id) }
    redirect_to itinerary_path(itinerary_schedule.itinerary.id)
  end

  def delete_itinerary_products
    ItineraryProduct.find(params[:itinerary_product_id]).destroy
    redirect_to itinerary_path(@resource)
  end

  def update_intinerary_products
    @itinerary_product = ItineraryProduct.find_by(id: params[:itinerary_product_id])
    @itinerary_product.update(timing: params[:timing])
  end

  def update_itinerary_product_schedule
    @itinerary_product = ItineraryProduct.find_by(id: params[:itinerary_product_id].to_s)
    @itinerary_product.update(schedule_id: params[:schedule_id])
  end

  def delete_itinerary_schedule
    ItinerarySchedule.find_by_id(params[:itinerary_schedule_id]).destroy
    @resource.update(duration: @resource.duration.to_i-1)
    redirect_to itinerary_path(@resource)
  end

  def add_new_schedule_itinerary
    @resource.itinerary_schedules.create!
    @resource.update(duration: @resource.duration.to_i+1)
    redirect_to itinerary_path(@resource)
  end

  def update_itinerary_product_description
    @itinerary_product = ItineraryProduct.find_by(id: params[:itinerary_product_id].to_s)
    @itinerary_product.update(description: params[:description])
  end

  def add_itinerary_traveller
    if params[:client_id].present?
      @client = User.find_by_id(params[:client_id])
      @travellers = @client.travellers
    end
    @clients = User.get_clients
  end

  def create_itinerary_traveller
    # if params[:user_id].present?
    #   update_itinerary_client
    # else
      itinerary_user = User.find_by_id(params[:user_id])
      if itinerary_user
        itinerary_user.itinerary_travellers.create(itinerary_id: params[:id])
        params[:traveller_ids].each do |traveller|
          itinerary_traveller = Traveller.find_by_id(traveller.to_i)

          itinerary_traveller.itinerary_travellers.create(itinerary_id: params[:id]) if itinerary_traveller
        end
      end
    # end
    redirect_to itinerary_path
  end

  def update_itinerary_client
    # binding.pry
    a = @resource.itinerary_travellers.where(memberable_type: 'Traveller').pluck(:memberable_id)
    b = User.find_by(id: params[:user_id]).travellers.pluck(:id)
    itinerary_travellers =  ItineraryTraveller.where(memberable_id: (a & b) - params[:traveller_ids].map(&:to_i)).destroy_all
    params[:traveller_ids].each do |id|
      # binding.pry
      traveller = Traveller.find_by_id(id.to_i)
      itinerary_traveller = ItineraryTraveller.find_by(memberable_id: id.to_i)
      traveller.itinerary_travellers.create(itinerary_id: params[:id]) if traveller !itinerary_traveller
    end
    # redirect_to 
  end

  def view_itinerary_details
    @itineray_schedules = @resource.itinerary_schedules
  end

  private
  
  def set_itinerary
    @resource = Itinerary.find_by(id: params[:id])
  end

  def itinerary_traveller_params
    params.permit!
  end

end
