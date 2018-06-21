class ItinerariesController < ApplicationController

  include InheritAction

  def create
    current_user.itineraries.create(resource_params)
    redirect_to itineraries_path
  end

  def create_itinerary_products
    @products = params["product"]
  end
end
