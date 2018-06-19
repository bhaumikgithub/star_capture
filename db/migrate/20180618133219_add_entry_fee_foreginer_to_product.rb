class AddEntryFeeForeginerToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :entry_fee_foreigner, :float
  end
end
