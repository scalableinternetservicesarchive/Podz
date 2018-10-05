json.extract! item, :id, :name, :description, :checked_out, :created_at, :updated_at
json.url item_url(item, format: :json)
