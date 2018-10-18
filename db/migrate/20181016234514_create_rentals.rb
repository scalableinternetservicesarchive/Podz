class CreateRentals < ActiveRecord::Migration[5.2]
  def change
    create_table :rentals do |t|
      t.integer :item_id
      t.integer :user_id
      t.integer :length_days
      t.integer :length_hours
      t.string :note

      t.timestamps
    end
  end
end
