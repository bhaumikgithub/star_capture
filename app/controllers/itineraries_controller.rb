class ItinerariesController < ApplicationController

  include InheritAction
  before_action :set_itinerary, only: [:create_itinerary_schedules, :delete_itinerary_products]

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

  def delete_itinerary_products
    ItineraryProduct.find(params[:itinerary_product_id]).destroy
    redirect_to itinerary_path(@resource)
  end

  def update_intinerary_products
    # binding.pry
    @itinerary_product = ItineraryProduct.find_by(id: params[:itinerary_product_id])
    @itinerary_product.update(timing: params[:timing])
    # render :json
  end

  private

  def itinerary_schedules_params
    params.require(:itinerary_schedules).permit!
  end

  def set_itinerary
    @resource = Itinerary.find_by(id: params[:id])
  end

  def create_itinerary_products
    @products = params["product"]
  end
end
