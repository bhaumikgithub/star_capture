class Template < ApplicationRecord
  serialize [ :name ,:price,:description, :short_description, :image, :multiple_images, :google_map_link, :product_type, :map_location, :location, :mon_to_sat_on, :mon_to_sat_open_time, :mon_to_sat_close_time, :entry_fee_adult, :entry_fee_toddler, :entry_fee_child, :entry_fee_senior_citizen, :ratings,:parking_type, :parking_fees]
  store_accessor [:name,:price, :description, :short_description, :image, :multiple_images, :google_map_link, :product_type, :map_location, :location, :mon_to_sat_on, :mon_to_sat_open_time, :mon_to_sat_close_time, :entry_fee_adult, :entry_fee_toddler, :entry_fee_child, :entry_fee_senior_citizen, :ratings,:parking_type, :parking_fees],  :required, :optional
end
