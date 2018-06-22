class Product < ApplicationRecord
  has_many_attached :multiple_images
  has_one_attached :image
  has_and_belongs_to_many :categories
  belongs_to :product_type
  has_many :product_comments, dependent: :destroy
  has_many :itinerary_products, dependent: :destroy
  has_many :itinerary_schedules, through: :itinerary_products
  ratyrate_rateable "ratings"

  acts_as_votable

  PARKING_TYPE = ['No Parking', 'Free', 'Paid', 'Valet']
  WEEK_DAYS = ['Monday', 'Tudeday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

  # after_validation :remove_images
  validate :add_errors

  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.pincode = geo.postal_code
      obj.country = geo.country
      obj.state = geo.state
      obj.address = geo.formatted_address
      obj.location = geo.formatted_address
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

  def validate_fields
    self.categories.last.category_template.get_optional_fields - ['mon_to_sat_on' , 'mon_to_sat_open_time', 'mon_to_sat_close_time', 'location', 'allow_ratings', 'allow_ratings_comment', 'allow_like', 'allow_comment']
  end

  def add_errors
    validate_fields.each do |field|
      errors.add(:base, "#{field.capitalize} can't be blank!") unless self.send(field).present?
    end
  end

  #get comment count for product
  def comment_count
    self.product_comments.count
  end

end
