class RenameReferenceInCategory < ActiveRecord::Migration[5.2]
  def change
    remove_column :categories, :template_id
  end
end
