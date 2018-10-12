class Item < ApplicationRecord
  belongs_to :category, required: false
  has_many :reviews
end
