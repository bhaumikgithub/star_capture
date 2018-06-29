class ItineraryTraveller < ApplicationRecord
  belongs_to :itinerary
  belongs_to :user
  belongs_to :memberable, :polymorphic => true

  scope :client_travellers, -> (client_id, itinerary_id) { where(memberable_type: 'Traveller', client_id: client_id, itinerary_id: itinerary_id) }
end
