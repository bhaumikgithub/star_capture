class ItinerariesController < ApplicationController

  include InheritAction
  before_action :set_itinerary, only: [:create_itinerary_schedules, :delete_itinerary_products]

  def create
    @resource = current_user.itineraries.new(resource_params)

    if @resource.save
      redirect_to @resource
    else
      render 'new'
    end
  end

  def update
    if params[:start_date] == nil
      @resource.update(start_date: nil, end_date: nil)
    end
    super
  end

  def create_itinerary_schedules
    @resource.itinerary_schedules.present? ? is_update = true : is_update = false
    count = @resource.duration_type == "Hours" ? 1 : @resource.duration.to_i
    for i in 1..count
      itinerary_schedules_params[i.to_s]["pickup_time"] = params[:itinerary_schedules][i.to_s]["pickup_time"].to_s

      itinerary_schedules_params[i.to_s]["drop_time"] = params[:itinerary_schedules][i.to_s]["drop_time"].to_s

      update_location_time(i)

      if is_update
        @resource.itinerary_schedules[i-1].update((itinerary_schedules_params[i.to_s]))
      else
        @resource.itinerary_schedules.create((itinerary_schedules_params[i.to_s]))
      end
    end
    redirect_to itinerary_path(@resource)
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

  private

  def itinerary_schedules_params
    params.require(:itinerary_schedules).permit!
  end

  def set_itinerary
    @resource = Itinerary.find_by(id: params[:id])
  end

  def update_location_time(i)
    if itinerary_schedules_params[i.to_s]["no_drop"] == "true"
      itinerary_schedules_params[i.to_s]["drop_time"] = nil
      itinerary_schedules_params[i.to_s]["drop_location"] = nil
    end
    if itinerary_schedules_params[i.to_s]["no_pickup"] == "true"
      itinerary_schedules_params[i.to_s]["pickup_time"] = nil
      itinerary_schedules_params[i.to_s]["pickup_location"] = nil
    end
  end
end
