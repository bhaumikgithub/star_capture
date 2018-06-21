class AddStatusToItineraries < ActiveRecord::Migration[5.2]
  def change
    add_column :itineraries, :status, :string, default: 'pending'
  end
end
