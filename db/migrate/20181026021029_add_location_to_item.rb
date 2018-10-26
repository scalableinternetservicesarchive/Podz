class AddLocationToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :latitude, :decimal
    add_column :items, :longitude, :decimal
  end
end
