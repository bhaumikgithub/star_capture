class AddColumnToItinerary < ActiveRecord::Migration[5.2]
  def change
    add_column :itineraries, :max_members, :string
    add_column :itineraries, :member_not_fixed, :boolean
    rename_column :itineraries, :members, :min_members
  end
end
