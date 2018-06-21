class ItinerariesController < ApplicationController

  include InheritAction
  before_action :set_itinerary, only: [:create_itinerary_schedules]

  def create
    @resource = current_user.itineraries.new(resource_params)

    if @resource.save
      redirect_to itineraries_path
    else
      render 'new'
    end
  end

  def create_itinerary_schedules
    @resource.itinerary_schedules.present? ? is_update = true : is_update = false
    count = @resource.duration_type == "Hours" ? 1 : @resource.duration.to_i
    for i in 1..count
      itinerary_schedules_params[i.to_s]["pickup_time"] = DateTime.parse((@resource.start_date.to_date+i-1).to_s+" "+params[:itinerary_schedules][i.to_s]["pickup_time"])

      itinerary_schedules_params[i.to_s]["drop_time"] = DateTime.parse((@resource.start_date.to_date+i-1).to_s+" "+params[:itinerary_schedules][i.to_s]["drop_time"])

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
    @itineraries = Itinerary.all
  end
  
  def get_itinerary_schedule
    itinerary = Itinerary.find_by_id(params[:itinerary])
    render json: { itinerary_schedules: itinerary.itinerary_schedules }
  end

  def create_itinerary_products
    binding.pry
     params[:itinerary_product][:product_ids] = params[:itinerary_product][:product_ids][0].split(',')

  end

  private

  def itinerary_schedules_params
    params.require(:itinerary_schedules).permit!
  end

  def set_itinerary
    @resource = Itinerary.find_by(id: params[:id])
  end

  def itinerary_product_params
    params.require(:itinerary_product).permit!
  end

 
end
