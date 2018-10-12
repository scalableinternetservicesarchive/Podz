class RenameCheckedOutToAvailable < ActiveRecord::Migration[5.2]
  def change
    rename_column :items, :checked_out, :available
  end
end
