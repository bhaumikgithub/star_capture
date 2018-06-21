class CreateItineraryProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :itinerary_products do |t|
      t.references :product, foreign_key: true
      t.references :itinerary_schedule, foreign_key: true
      t.datetime :timing

      t.timestamps
    end
  end
end
