# frozen_string_literal: true

class ItinerariesController < ApplicationController

  include InheritAction

  before_action :set_itinerary, only: [:delete_itinerary_products, :delete_itinerary_schedule, :add_new_schedule_itinerary,:add_itinerary_traveller, :create_itinerary_traveller, :delete_itinerary_client]

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
      @itinerary_client = ItineraryTraveller.find_by(memberable_id: params[:client_id], itinerary_id: params[:id])
      @itinerary_traveller = ItineraryTraveller.client_travellers(params[:client_id], params[:id]).pluck(:memberable_id)
    end
    @clients = User.get_clients
  end

  def create_itinerary_traveller
    itinerary_user = User.find_by_id(params[:user_id])
    if itinerary_user && params[:traveller_ids].present?
      itinerary_user = itinerary_user.itinerary_travellers.find_or_create_by(itinerary_id: params[:id])
      itinerary_user.update(price: params[:price], description: params[:description], start_date: params[:start_date])
      travellers = Traveller.where(id: params[:traveller_ids]).pluck(:id)
      client_traveller_ids = ItineraryTraveller.client_travellers(params[:user_id].to_i, params[:id]).pluck(:memberable_id)
      params[:traveller_ids].each do |traveller_id|
        ItineraryTraveller.create(memberable_id: traveller_id, memberable_type: 'Traveller', client_id: params[:user_id], itinerary_id: params[:id]) if (travellers.include? traveller_id.to_i) && !(client_traveller_ids.include? traveller_id.to_i)
      end
    end
    client_travellers = ItineraryTraveller.client_travellers(params[:user_id].to_i, params[:id]).where.not(memberable_id: params[:traveller_ids]).destroy_all
    redirect_to view_itinerary_details_itinerary_path(@resource)
  end

  def delete_itinerary_client
    itinerary_client = ItineraryTraveller.find_by(memberable_id: params[:memberable_id])
    ItineraryTraveller.client_travellers(params[:memberable_id], params[:id]).destroy_all if itinerary_client
    itinerary_client.destroy
    redirect_to itinerary_path(@resource) 
  end


  def view_itinerary_details
    @resource = Itinerary.includes(:itinerary_schedules => [ { :itinerary_products => :product} ]).find_by(id: params[:id])
  end

  private
  
  def set_itinerary
    @resource = Itinerary.find_by(id: params[:id])
  end

  def itinerary_traveller_params
    params.permit!
  end

end
