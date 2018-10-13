class Rename < ActiveRecord::Migration[5.2]
  def change
    if column_exists?(:items, :name)
      rename_column :items, :name, :title
    end
  end
end
