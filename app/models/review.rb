class Review < ApplicationRecord
  belongs_to :user, required: false
  belongs_to :item, required: false
  validates :rating, :inclusion => 1..5
  validates :title, length: {minimum: 1}
  validates :body, length: {minimum: 1 , maximum: 1400}
end
