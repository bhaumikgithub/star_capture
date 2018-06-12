class AddCategoryTemplateToCategory < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :category_template, foreign_key: true
  end
end
