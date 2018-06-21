class CreateItineraries < ActiveRecord::Migration[5.2]
  def change
    create_table :itineraries do |t|
      t.string :name
      t.datetime :start_date
      t.string :duration
      t.datetime :end_date
      t.string :price
      t.string :expenses
      t.string :members
      t.boolean :not_fixed
      t.references :transport_type, foreign_key: true

      t.timestamps
    end
  end
end
