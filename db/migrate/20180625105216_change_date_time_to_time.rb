class ChangeDateTimeToTime < ActiveRecord::Migration[5.2]
  def change
    change_column :itinerary_schedules, :pickup_time, :time
    change_column :itinerary_schedules, :drop_time, :time
  end
end
