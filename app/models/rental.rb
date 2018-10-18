class Rental < ApplicationRecord
  belongs_to :item, required: true
  belongs_to :user, required: true
end
