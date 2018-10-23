class Review < ApplicationRecord
  belongs_to :item, required: false
  validates :rating, :inclusion => 1..5
  validates :title, length: {minimum: 1}
  validates :body, length: {minimum: 5, maximum: 140}
end
