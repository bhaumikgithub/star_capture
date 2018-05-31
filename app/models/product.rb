class Product < ApplicationRecord
  has_many_attached :images
  has_and_belongs_to_many :categories

  validates :name, :price, :category_ids, presence: true
end
