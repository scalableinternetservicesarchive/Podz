class Item < ApplicationRecord
  belongs_to :category, required: false

end
