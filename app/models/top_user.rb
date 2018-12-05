class TopUser < ApplicationRecord
  has_one :user

  def limit_size
    while TopItem.count > 10
      TopItem.last.destroy
    end
  end
end
