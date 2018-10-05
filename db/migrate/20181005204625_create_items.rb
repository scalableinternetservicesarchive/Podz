class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.boolean :checked_out

      t.timestamps
    end
  end
end
