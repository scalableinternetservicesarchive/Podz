class RatingsCalculatorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Check if table exists (necessary to pass Travis CI checks)
    if ActiveRecord::Base.connection.table_exists? 'top_users'
      sql = "SELECT users.id AS id, COUNT(rating) AS count, SUM(rating) AS sum
             FROM users JOIN items ON (users.id = items.user_id)
                        JOIN reviews ON (items.id = reviews.item_id)
             GROUP BY users.id
             ORDER BY sum DESC"

      users = ActiveRecord::Base.connection.execute sql
      top_users = users[0...10]

      # # Calculate top 10 Users
      # users = User.all.sort_by { |user| user.rating * user.items.length }
      # users.reverse!
      # users = users[0...10]

      # If a top user ranking has changed, update
      ActiveRecord::Base.transaction do
        index = 0
        TopUser.all.each do |user|
          unless user.user_id == top_users[index]["id"]
            puts "Updating"
            user.update(user_id: top_users[index]["id"])
          end
          index += 1
        end
        while index < 10 && index < top_users.length
          TopUser.create(user_id: top_users[index]["id"])
          index += 1
        end
      end
    end

    if ActiveRecord::Base.connection.table_exists? 'top_items'

      sql = "SELECT items.id AS id, COUNT(rating) AS count, SUM(rating) AS sum
             FROM items JOIN reviews ON (items.id = reviews.item_id)
             GROUP BY items.id
             ORDER BY sum DESC"

      items = ActiveRecord::Base.connection.execute sql
      top_items = items[0...10]

      # If a top item ranking has changed, update
      ActiveRecord::Base.transaction do
        index = 0
        TopItem.all.each do |item|
          unless item.item_id == top_items[index]["id"]
            item.update(item_id: top_items[index]["id"])
          end
          index += 1
        end
        while index < 10 && index < top_items.length
          TopItem.create(item_id: top_items[index]["id"])
          index += 1
        end
      end
    end

    RatingsCalculatorJob.set(wait: 10.seconds).perform_later
  end
end