json.extract! review, :id, :item_id, :title, :body, :rating, :user_id, :anonymous, :created_at, :updated_at
json.url review_url(review, format: :json)
