class AddCurrencyToCategoryTemplate < ActiveRecord::Migration[5.2]
  def change
    add_column :category_templates, :currency, :jsonb,  default: {required: false, optional: false}
  end
end
