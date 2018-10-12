class Review < ApplicationRecord
  belongs_to :item, required: false
end
