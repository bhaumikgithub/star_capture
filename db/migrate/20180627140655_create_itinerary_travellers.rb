class CreateItineraryTravellers < ActiveRecord::Migration[5.2]
  def change
    create_table :itinerary_travellers do |t|
      t.references :itinerary, foreign_key: true
      t.references :memberable, polymorphic: true
      t.timestamps
    end
  end
end
