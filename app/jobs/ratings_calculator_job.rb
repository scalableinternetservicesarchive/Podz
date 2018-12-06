class RatingsCalculatorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Check if table exists (necessary to pass Travis CI checks)
    if ActiveRecord::Base.connection.table_exists? 'top_users'
      sql = "SELECT users.id AS id, COUNT(rating) AS count, SUM(rating) AS sum
           FROM users JOIN items ON (users.id = items.user_id)
                      JOIN reviews ON (items.id = reviews.item_id)
           GROUP BY users.id
           ORDER BY sum DESC
           LIMIT 10"

      users = ActiveRecord::Base.connection.execute sql
      length = users.class == Array ? users.length : users.ntuples  # Necessary to handle PG return values in production

      return unless length > 0

      # If a top user ranking has changed, update
      ActiveRecord::Base.transaction do
        [10, length].min.times do |i|
          user = TopUser.find_by(id: i + 1)
          if user.nil?
            TopUser.create(id: i + 1, user_id: users[i]["id"])
          elsif user.user_id != users[i]["id"]
            user.update(user_id: users[i]["id"])
          end
        end

        # Get rid of any extra top users
        if TopUser.count > 10
          TopUser.where("id > 10").delete_all
        end
      end
    end

    if ActiveRecord::Base.connection.table_exists? 'top_items'

      sql = "SELECT items.id AS id, COUNT(rating) AS count, SUM(rating) AS sum
           FROM items JOIN reviews ON (items.id = reviews.item_id)
           GROUP BY items.id
           ORDER BY sum DESC"

      items = ActiveRecord::Base.connection.execute sql
      length = items.class == Array ? items.length : items.ntuples  # Necessary to handle PG return values in production

      return unless length > 0

      # If a top item ranking has changed, update
      ActiveRecord::Base.transaction do
        [10, length].min.times do |i|
          item = TopItem.find_by(id: i + 1)
          if item.nil?
            TopItem.create(id: i + 1, item_id: items[i]["id"])
          elsif item.item_id != items[i]["id"]
            item.update(item_id: items[i]["id"])
          end
        end

        # Get rid of any extra top items
        if TopItem.count > 10
          TopItem.where("id > 10").delete_all
        end
      end
    end
  ensure
    RatingsCalculatorJob.set(wait: 15.seconds).perform_later
  end
end