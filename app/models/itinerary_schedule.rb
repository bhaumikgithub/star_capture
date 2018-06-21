class ItinerarySchedule < ApplicationRecord
  belongs_to :itinerary
  has_many :itinerary_products
end
