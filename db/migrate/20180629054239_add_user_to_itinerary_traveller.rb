class AddUserToItineraryTraveller < ActiveRecord::Migration[5.2]
  def change
    add_column :itinerary_travellers, :client_id, :integer
  end
end
