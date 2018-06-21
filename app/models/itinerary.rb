class Itinerary < ApplicationRecord
  belongs_to :transport_type
  has_many :itinerary_schedules, dependent: :destroy
  belongs_to :client, foreign_key: :client_id, class_name: 'User', optional: true
  belongs_to :user, foreign_key: :user_id, class_name: 'User', optional: true
end
