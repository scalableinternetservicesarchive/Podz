class DropReviews < ActiveRecord::Migration[5.2]
  def up
    drop_table :reviews
  end
end
