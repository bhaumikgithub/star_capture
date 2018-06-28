# frozen_string_literal: true

class TransportType < ApplicationRecord
  has_one :itinerary,dependent: :nullify
  validates :name, presence:  true
end
