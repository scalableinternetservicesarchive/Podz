class CreateTopUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :top_users do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
