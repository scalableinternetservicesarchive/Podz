class AddPriceToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :price_hourly_usd, :float
    add_column :items, :price_daily_usd, :float
  end
end
