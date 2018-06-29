class AddFieldsToItineraryTraveller < ActiveRecord::Migration[5.2]
  def change
    add_column :itinerary_travellers, :price, :float
    add_column :itinerary_travellers, :start_date, :date
    add_column :itinerary_travellers, :description, :text
  end
end
