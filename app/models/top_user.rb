class TopUser < ApplicationRecord
  before_create :limit_size
  after_create :limit_size
  has_one :user

  def limit_size
    while TopItem.count > 10
      TopItem.last.destroy
    end
  end
end
