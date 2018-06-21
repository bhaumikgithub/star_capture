class ItinerariesController < ApplicationController

  include InheritAction

  def create
    current_user.itineraries.create(resource_params)
    redirect_to itineraries_path
  end
end
