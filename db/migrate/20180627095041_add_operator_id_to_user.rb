class AddOperatorIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :operator
  end
end
