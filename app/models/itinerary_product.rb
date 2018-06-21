class ItineraryProduct < ApplicationRecord
  belongs_to :product
  belongs_to :itinerary_schedule
end
