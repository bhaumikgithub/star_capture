class AddFieldsToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :latitude, :float
    add_column :products, :longitude, :float
    add_column :products, :address, :text
    add_column :products, :city, :string
    add_column :products, :state, :string
    add_column :products, :country, :string
    add_column :products, :pincode, :string
  end
end
