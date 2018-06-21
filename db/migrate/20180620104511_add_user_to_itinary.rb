class AddUserToItinary < ActiveRecord::Migration[5.2]
  def change
    add_column :itineraries, :client_id, :integer
    add_reference :itineraries, :user, foreign_key: true
  end
end
