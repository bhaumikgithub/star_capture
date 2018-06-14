class AddTimingsToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :timings, :jsonb
  end
end
