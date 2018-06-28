# frozen_string_literal: true

class Traveller < ApplicationRecord
  belongs_to :user
  has_many :itinerary_travellers, :as => :memberable
end
