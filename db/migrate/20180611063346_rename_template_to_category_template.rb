class RenameTemplateToCategoryTemplate < ActiveRecord::Migration[5.2]
  def change
    rename_table :templates, :category_templates
  end
end
