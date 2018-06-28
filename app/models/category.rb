# frozen_string_literal: true

class Category < ApplicationRecord
  has_and_belongs_to_many :products
  belongs_to :category_template
  validates :name, presence:  true, uniqueness:  {case_sensitive: false}
  validates :category_template, presence: true
end
