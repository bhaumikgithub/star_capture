class AddCurrencyToCategoryTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :category_templates, :currency, :string
  end
end
