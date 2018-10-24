class Item < ApplicationRecord
  belongs_to :category, required: false
  belongs_to :user,     required: false
  has_many :reviews
  def self.conditions
    ['Like new', 'Almost new', 'Good', 'Decent', 'Ok', 'Barely Working 100%', 'Not working 100%']
  end
end
