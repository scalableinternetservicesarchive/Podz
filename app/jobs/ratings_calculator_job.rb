class RatingsCalculatorJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Queue job in the beginning in case the job errors out
    RatingsCalculatorJob.set(wait: 15.seconds).perform_later

    # Check if table exists (necessary to pass Travis CI checks)
    if ActiveRecord::Base.connection.table_exists? 'top_users'
      sql = "SELECT users.id AS id, COUNT(rating) AS count, SUM(rating) AS sum
             FROM users JOIN items ON (users.id = items.user_id)
                        JOIN reviews ON (items.id = reviews.item_id)
             GROUP BY users.id
             ORDER BY sum DESC"

      users = ActiveRecord::Base.connection.execute sql
      length = users.class == Array ? users.length : users.ntuples  # Necessary to handle PG return values in production

      return unless length > 0

      # If a top user ranking has changed, update
      ActiveRecord::Base.transaction do
        index = 0
        TopUser.all[0...length].each do |user|
          unless user.user_id == users[index]["id"]
            puts "Updating"
            user.update(user_id: users[index]["id"])
          end
          index += 1
        end
        while index < 10 && index < length
          TopUser.create(user_id: users[index]["id"])
          index += 1
        end
        extra_users = TopUser.all[length..TopUser.count]
        unless extra_users.nil?
          extra_users.each { |top_user| top_user.delete }
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
        index = 0
        TopItem.all.each do |item|
          unless item.item_id == items[index]["id"]
            item.update(item_id: items[index]["id"])
          end
          index += 1
        end
        while index < 10 && index < length
          TopItem.create(item_id: items[index]["id"])
          index += 1
        end
      end
    end
  end
end