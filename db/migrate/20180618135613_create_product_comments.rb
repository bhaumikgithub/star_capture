class CreateProductComments < ActiveRecord::Migration[5.2]
  def change
    create_table :product_comments do |t|
      t.references :product, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end
