class ItinerarySchedule < ApplicationRecord
  belongs_to :itinerary

  has_many :itinerary_products, dependent: :destroy
  has_many :products, through: :itinerary_products
end
