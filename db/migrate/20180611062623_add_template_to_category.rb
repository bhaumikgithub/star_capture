class AddTemplateToCategory < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :template, foreign_key: true
  end
end
