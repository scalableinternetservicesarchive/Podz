class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :item_id
      t.string :title
      t.text :body
      t.integer :rating
      t.integer :user_id
      t.boolean :anonymous

      t.timestamps
    end
  end
end
