# frozen_string_literal: true

class ProductComment < ApplicationRecord
  belongs_to :product
  belongs_to :user

  validates :comment, presence:  true
end
