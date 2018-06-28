# frozen_string_literal: true

class CategoryTemplate < ApplicationRecord
  serialize [ :name ,:price,:description, :short_description, :image, :multiple_images, :google_map_link, :product_type, :map_location, :location, :mon_to_sat_on, :mon_to_sat_open_time, :mon_to_sat_close_time, :entry_fee_adult, :entry_fee_toddler, :entry_fee_child, :entry_fee_senior_citizen, :ratings,:parking_type, :parking_fees]
  store_accessor [:name,:price, :description, :short_description, :image, :multiple_images, :google_map_link, :product_type, :map_location, :location, :mon_to_sat_on, :mon_to_sat_open_time, :mon_to_sat_close_time, :entry_fee_adult, :entry_fee_toddler, :entry_fee_child, :entry_fee_senior_citizen, :ratings,:parking_type, :parking_fees],  :required, :optional

  has_one :category, dependent: :nullify
  has_many :products, through: :category


  def get_template_fields
    self.attributes.except('id', 'created_at', 'template_name', 'updated_at')
  end

  def get_required_true
    arr = []
    get_template_fields.each do |key, value|
      if value.present?
        arr << key if value['required'] == 'true'
      end
    end
    arr
  end


  def get_optional_fields
    arr = []
    get_template_fields.each do |key, value|
      if value.present?
        arr << key if value['optional'] == 'false' && value['required'] == 'true'
      end
    end
    arr
  end

  CategoryTemplate.column_names.each do |template_field|
    define_method "is_#{template_field}?" do
      return true if self.get_required_true.include? template_field
    end
  end

  CategoryTemplate.column_names.each do |template_field|
    define_method "is_#{template_field}_optional?" do
      return true if self.get_optional_fields.include? template_field
    end
  end

  def true?(obj)
    obj.to_s == "true"
  end
  
end
