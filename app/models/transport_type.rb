class TransportType < ApplicationRecord
  has_one :itinerary
  validates :name, presence:  true
end
