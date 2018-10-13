class RenameCheckedOutToAvailable < ActiveRecord::Migration[5.2]
  def change
    if column_exists?(:items, :checked_out)
      rename_column :items, :checked_out, :available
    end
  end
end
