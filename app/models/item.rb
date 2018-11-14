class Item < ApplicationRecord
  belongs_to :category, required: false
  belongs_to :user,     required: false
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one :top_item, dependent: :destroy

  validates :title, length: {minimum: 1}
  validates :description, length: {minimum: 1}
  validates :category_id, presence:  true
  validates :condition, presence:  true
  validates :price_hourly_usd, :inclusion => 0..99999, presence: true, unless: ->(item){item.price_daily_usd.present?}
  validates :price_daily_usd, :inclusion => 0..99999, presence: true, unless: ->(item){item.price_hourly_usd.present?}
  def self.conditions
    ['Like new', 'Almost new', 'Good', 'Decent', 'Ok', 'Barely Working 100%', 'Not working 100%']
  end

  def rating
    reviews.length != 0 ? reviews.sum(:rating) / reviews.length : 0
  end
end
