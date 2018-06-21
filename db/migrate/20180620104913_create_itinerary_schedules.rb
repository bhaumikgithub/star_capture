class CreateItinerarySchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :itinerary_schedules do |t|
      t.datetime :pickup_time
      t.text :pickup_location
      t.boolean :no_pickup
      t.datetime :drop_time
      t.text :drop_location
      t.boolean :no_drop
      t.references :itinerary, foreign_key: true

      t.timestamps
    end
  end
end
