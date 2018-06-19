class AddCommentToRate < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :comment, :string
  end
end
