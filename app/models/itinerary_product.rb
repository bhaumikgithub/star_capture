# frozen_string_literal: true

class ItineraryProduct < ApplicationRecord
  belongs_to :product
  belongs_to :itinerary_schedule
  belongs_to :schedule
  
end
