class RenameTableName < ActiveRecord::Migration[5.2]
  def change
    rename_table :family_members, :travellers
  end
end
