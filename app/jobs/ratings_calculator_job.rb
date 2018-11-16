class RatingsCalculatorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Check if table exists (necessary to pass Travis CI checks)
    if ActiveRecord::Base.connection.table_exists? 'top_users'
      # Calculate top 10 Users
      users = User.all.sort_by { |user| user.rating * user.items.length }
      users.reverse!
      users = users[0...10]

      # If a top user ranking has changed, update
      ActiveRecord::Base.transaction do
        index = 0
        TopUser.all.each do |user|
          unless user.user_id == users[index].id
            user.update(user_id: users[index].id)
          end
          index += 1
        end
        while index < 10 && index < users.count
          TopUser.create(user_id: users[index].id)
          index += 1
        end
      end
    end

    if ActiveRecord::Base.connection.table_exists? 'top_items'
      # Calculate top 10 Items
      items = Item.all.sort_by { |item| [item.rating * (item.reviews.length > 2 ? 1 : 0), item.reviews.length] }
      items.reverse!
      items = items[0...10]

      # If a top item ranking has changed, update
      ActiveRecord::Base.transaction do
        index = 0
        TopItem.all.each do |item|
          unless item.item_id == items[index].id
            item.update(item_id: items[index].id)
          end
          index += 1
        end
        while index < 10 && index < items.count
          TopItem.create(item_id: items[index].id)
          index += 1
        end
      end
    end

    RatingsCalculatorJob.set(wait: 10.seconds).perform_later
  end
end