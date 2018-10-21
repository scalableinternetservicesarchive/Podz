class Review < ApplicationRecord
  belongs_to :item, required: false
  validates :rating, :inclusion => 1..5
end
