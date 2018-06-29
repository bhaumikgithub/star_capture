class ItineraryTraveller < ApplicationRecord
  belongs_to :itinerary
  belongs_to :user
  belongs_to :memberable, :polymorphic => true
  has_many :travellers, ->(o) { where "client_id = ?", o.memberable.id }, foreign_key: :client_id, class_name: 'ItineraryTraveller'
end
