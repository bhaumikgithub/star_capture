class ItineraryTraveller < ApplicationRecord
  belongs_to :itinerary
  belongs_to :user
  belongs_to :traveller
  belongs_to :memberable, :polymorphic => true
end
