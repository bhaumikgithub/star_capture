class AddFieldToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :description, :text
    add_column :products, :short_description, :text
    add_column :products, :google_map_link, :string
    add_reference :products, :product_type, foreign_key: true
    add_column :products, :map_location, :string
    add_column :products, :location, :string
    add_column :products, :mon_to_sat_on, :boolean
    add_column :products, :mon_to_sat_open_time, :datetime
    add_column :products, :mon_to_sat_close_time, :datetime
    add_column :products, :entry_fee_adult, :float
    add_column :products, :entry_fee_toddler, :float
    add_column :products, :entry_fee_child, :float
    add_column :products, :entry_fee_senior_citizen, :float
    add_column :products, :ratings, :string
    add_column :products, :parking_type, :string
    add_column :products, :parking_fees, :float
  end
end
