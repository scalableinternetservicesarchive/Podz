class AddHistoryFieldToRental < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :history, :boolean, default: false
  end
end
