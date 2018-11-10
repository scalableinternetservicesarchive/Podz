class User < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :reviews
  has_many :favorites, dependent: :destroy
  has_many :reviews, through: :items
  has_one :top_user, dependent: :destroy

  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :display_name,  presence: true, length: { maximum: 50 }
  validates :email,         presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX },
                            uniqueness: { case_sensitive: false }
  validates :password,      presence: true, length: { minimum: 6 }, allow_nil: true
  validates :biography,     length: { maximum: 2000 }
  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token) )
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def rating
    reviews.length != 0 ? reviews.sum(:rating) / reviews.length : 0
  end

  # Returns true if the given item is favorited by the user
  def favorite?(item)
    !Favorite.find_by(item_id: item.id, user_id: id).nil?
  end
end
