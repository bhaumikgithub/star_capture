class AddFieldsInProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :allow_comment, :boolean, default: false
    add_column :products, :view_comments, :boolean, default: false
    add_column :products, :allow_like, :boolean, default: false
    add_column :products, :view_likes, :boolean, default: false

  end
end
