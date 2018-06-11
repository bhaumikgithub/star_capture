class Product < ApplicationRecord
  has_many_attached :multiple_images
  has_one_attached :image
  has_and_belongs_to_many :categories


  # after_validation :remove_images

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
  after_validation :reverse_geocode

  def full_address
    [self.address].compact.join(', ')
  end


  def remove_images
    return if self.errors.empty?
    # Purge the blob
    images_attachments.each do |image|
      image.blob.purge
    end
    images.purge #Purge attachment
  end
end
