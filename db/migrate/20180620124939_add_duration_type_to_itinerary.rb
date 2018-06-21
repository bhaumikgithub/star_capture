class AddDurationTypeToItinerary < ActiveRecord::Migration[5.2]
  def change
    add_column :itineraries, :duration_type, :string
  end
end
