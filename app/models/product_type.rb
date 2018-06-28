# frozen_string_literal: true

class ProductType < ApplicationRecord
  has_one :product
end
