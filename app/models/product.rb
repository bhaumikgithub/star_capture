class Product < ApplicationRecord
  has_many_attached :images
  has_and_belongs_to_many :categories

  validates :name, :price, :category_ids, presence: true

  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.pincode = geo.postal_code
      obj.country = geo.country
      obj.state = geo.state
      obj.address = geo.formatted_address
    end
  end
  after_validation :update_pin, if: :pincode_changed?
  after_validation :reverse_geocode

  def full_address
    [self.address].compact.join(', ')
  end

  def update_pin
    geocoder = Geocoder.search(self.pincode)
    self.latitude = geocoder.first.latitude
    self.longitude = geocoder.first.longitude
  end
end
