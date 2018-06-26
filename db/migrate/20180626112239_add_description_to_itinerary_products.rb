class AddDescriptionToItineraryProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :itinerary_products, :description, :text
  end
end
