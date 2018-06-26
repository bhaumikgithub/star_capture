class AddScheduleToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :itinerary_products, :schedule_id, :integer
  end
end
