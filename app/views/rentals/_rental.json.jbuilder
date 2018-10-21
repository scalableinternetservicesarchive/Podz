json.extract! rental, :id, :item_id, :user_id, :length_days, :length_hours, :note, :created_at, :updated_at
json.url rental_url(rental, format: :json)
