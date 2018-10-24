class Item < ApplicationRecord
  belongs_to :category, required: false
  belongs_to :user,     required: false
  has_many :reviews
  validates :title, length: {minimum: 1}
  validates :description, length: {minimum: 1}
  validates :price_hourly_usd, :inclusion => 0..999999
  validates :price_daily_usd, :inclusion => 0..999999
end
