class AddUserToProductComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :product_comments, :user, foreign_key: true
  end
end
