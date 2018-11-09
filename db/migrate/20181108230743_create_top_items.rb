class CreateTopItems < ActiveRecord::Migration[5.2]
  def change
    create_table :top_items do |t|
      t.integer :item_id

      t.timestamps
    end
  end
end
