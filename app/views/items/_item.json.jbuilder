json.extract! item, :id, :title, :description, :price_hourly_usd, :price_daily_usd, :available, :created_at, :updated_at
json.url item_url(item, format: :json)
