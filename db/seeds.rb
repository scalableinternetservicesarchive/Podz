# Setting environment variables to correctly form sql query strings for sqlite vs. postgres
puts '=============================='
if Rails.env == 'test' || Rails.env == 'development'
  puts 'IN LOCAL MODE (' + Rails.env + ')'
  how_many = {user: 100, items_per_user: 1, category: 3, rentals_per_user: 2, favorites_per_user: 0}
  col_name_delim = "`"  # sqlite3
  val_delim = '"'       # sqlite3
  direct_sql_inject = true
  true_val = 1
  false_val = 0
else
  # Production environment - use postgres
  puts 'IN REMOTE MODE (production)'
  how_many = {user: 1000, items_per_user: 8, category: 10, rentals_per_user: 3, favorites_per_user: 3}
  col_name_delim = "" # postgres
  val_delim = "'"     # postgres
  direct_sql_inject = true
  true_val = "TRUE"
  false_val = "FALSE"
end
puts '=============================='

if direct_sql_inject
  # turn off logger (we turn it back @ end of file)
  # (This prevents rails db:seed from spewing)
  ActiveRecord::Base.logger.level = 1
end

def dict_to_db_str(d, cols, delim)
  # Usage:
  # > di = {name: "Justin", age: 34, ssn: "\"Um no,\" he said"}
  #   => {:name=>"Justin", :age=>34, :ssn=>"\"Um no,\" he said"}
  # > cols = ["name","age","ssn","nope"]
  # > puts dict_to_db_str(di,cols,"'")
  #   ('Justin', 34, '\'Um no,\' he said', nil)

  if d.keys.first.is_a? Symbol and cols.first.is_a? String
    cols.map! {|s| s.to_sym}
  elsif d.keys.first.is_a? String and cols.first.is_a? Symbol
    cols.map! {|s| s.to_s}
  end
  col_vals = d.values_at(*cols)
  col_string = col_vals.inspect
  col_string[0] = '('
  col_string[-1] = ')'
  col_string.gsub! '"', delim
  col_string.gsub! "'NULL'", "NULL" # Just for postgres, won't mess with sqlite
  return col_string
end

NOW_DT = DateTime.current
NOW_STR = NOW_DT.strftime("%FT%T")

# USERS
cols = User.column_names - ["remember_digest"]
delimited_cols = cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
sql = "INSERT INTO users (#{delimited_cols.join(',')}) VALUES "
user_ids = (1..how_many[:user]).to_a

PASSWORD = "foobar"
PASSWORD_DIGEST = User.digest(PASSWORD)

user_ids.each do |i|

  user_values = {
      id: i,
      display_name: "User #{i}",
      password: PASSWORD,
      password_confirmation: PASSWORD,
      email: "user#{i}@example.com",
      biography: Faker::Lorem.sentences(5).join(" "),
      admin: false
  }

  if i == 1
    # Admin user
    user_values.merge! display_name: "Admin User", email: "admin@example.com", admin: true
  end

  if direct_sql_inject
    user_values[:created_at]      = NOW_STR
    user_values[:updated_at]      = NOW_STR
    user_values[:admin]           = user_values[:admin] ? true_val : false_val
    user_values[:password_digest] = PASSWORD_DIGEST
    vals = dict_to_db_str(user_values, cols, val_delim)
    sql += i==1 ? vals : ',' + vals
  else
    user_values.delete(:id)
    User.create!(user_values)
  end
end

if direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

puts "Generated #{User.count} users"

# CATEGORIES
cols = Category.column_names
delimited_cols = cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
sql = "INSERT INTO categories (#{delimited_cols.join(',')}) VALUES "
category_ids = (1..how_many[:category]).to_a

category_ids.each do |i|

  category_vals = {
      id: i,
      name: "Category #{i}",
      description: Faker::Lorem::sentences(5).join(" ")
  }

  if direct_sql_inject
    category_vals[:created_at]      = NOW_STR
    category_vals[:updated_at]      = NOW_STR
    vals = dict_to_db_str(category_vals, cols, val_delim)
    sql += i==1 ? vals : ',' + vals
  else
    category_vals.delete(:id)
    Category.create!(category_vals)
  end
end

if direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

puts "Generated #{Category.count} categories"

# ITEMS
cols = Item.column_names
delimited_cols = cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
sql = "INSERT INTO items (#{delimited_cols.join(',')}) VALUES "
item_ids = (1..(how_many[:user]*how_many[:items_per_user])).to_a
conditions = Item.conditions.to_a

item_ids.each do |i|

  item_vals = {
      id: i,
      title: "Item #{i}",
      description: Faker::Lorem.sentences(5).join(" "),
      available: true,
      category_id: rand(1..how_many[:category]),
      price_hourly_usd: rand(1..25),
      price_daily_usd: rand(25..50),
      user_id: ((i - 1) / how_many[:items_per_user]) + 1, # Ensures items assigned to users in order of user ID
      condition: conditions[rand(0...conditions.length)],
      latitude: 34.41333 + rand(1..3)**(-(rand(1..2))),
      longitude: -119.86097 + rand(1..3)**(-rand(1..2)),
  }

  if direct_sql_inject
    item_vals[:created_at]      = NOW_STR
    item_vals[:updated_at]      = NOW_STR
    item_vals[:available]       = true_val
    vals = dict_to_db_str(item_vals, cols, val_delim)
    sql += i==1 ? vals : ',' + vals
  else
    item_vals.delete(:id)
    Item.create!(item_vals)
  end
end

if direct_sql_inject
  ActiveRecord::Base.connection.execute sql
end

puts "Generated #{Item.count} items"

# RENTAL HISTORY
# Rentals
cols = Rental.column_names - ["length_days", "length_hours", "note"]
delimited_cols = cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
sql = "INSERT INTO rentals (#{delimited_cols.join(',')}) VALUES "

# Reviews
review_cols = Review.column_names
delimited_rev_cols = review_cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
review_sql = "INSERT INTO reviews (#{delimited_rev_cols.join(',')}) VALUES "
review_id = 0

# Items to update as unavailable
unavailable_item_ids = []

if how_many[:rentals_per_user] != 0
  user_ids.each do |user_id|
    how_many[:rentals_per_user].times do |i|

      review_id += 1

      item_id = ((user_id + 1) % how_many[:user]) * how_many[:items_per_user] + i

      rental_vals = {
          id: i + 1 + (user_id - 1) * how_many[:rentals_per_user],
          item_id: item_id,
          user_id: user_id,
          history: i + 1 != how_many[:rentals_per_user]
      }

      if i + 1 == how_many[:rentals_per_user]
        # Item is not checked in
        unavailable_item_ids.append(item_id)
      else
        # Make a review
        review_vals = {
            id: review_id,
            item_id: item_id,
            user_id: user_id,
            title: Faker::Lorem.words(5).join(" "),
            body: Faker::Lorem.sentences(rand(1..5)).join(" "),
            rating: rand(1..5),
            anonymous: rand(0..1) == 1 ? true_val : false_val
        }

        if direct_sql_inject
          review_vals[:created_at]    = NOW_STR
          review_vals[:updated_at]    = NOW_STR
          vals = dict_to_db_str(review_vals, review_cols, val_delim)
          review_sql += i == 0 && user_id == 1 ? vals : ',' + vals
        else
          review_vals.delete(:id)
          review_vals[:anonymous] == 1 ? true : false
          Review.create!(review_vals)
        end

      end

      if direct_sql_inject
        rental_vals[:created_at]      = NOW_STR
        rental_vals[:updated_at]      = NOW_STR

        if rental_vals[:history]
          rental_vals[:check_in_date] = NOW_STR
        else
          rental_vals[:check_in_date] = "NULL"
        end

        rental_vals[:history]         = rental_vals[:history] ? true_val : false_val

        vals = dict_to_db_str(rental_vals, cols, val_delim)
        sql += i == 0 && user_id == 1 ? vals : ',' + vals
      else
        rental_vals.delete(:id)

        if rental_vals[:history]
          rental_vals[:check_in_date] = NOW_DT
        end

        Rental.create!(rental_vals)
        Item.update(available: i + 1 != how_many[:rentals_per_user])
      end
    end
  end

  if direct_sql_inject
    ActiveRecord::Base.connection.execute sql
    ActiveRecord::Base.connection.execute "UPDATE items SET available=#{false_val} WHERE id IN (#{unavailable_item_ids.join(",")})"
    ActiveRecord::Base.connection.execute review_sql
  end
end

puts "Generated #{Rental.count} rentals"
puts "Generated #{Review.count} reviews"

# Favorites
cols = Favorite.column_names
delimited_cols = cols.map {|s| col_name_delim + "#{s}" + col_name_delim}
sql = "INSERT INTO favorites (#{delimited_cols.join(',')}) VALUES "

if how_many[:favorites_per_user] != 0
  user_ids.each do |user_id|
    item_id = rand(1..(how_many[:user] * how_many[:items_per_user] / how_many[:favorites_per_user]))
    how_many[:favorites_per_user].times do |i|
      favorite_vals = {
          id: i + 1 + (user_id - 1) * how_many[:favorites_per_user],
          user_id: user_id,
          item_id: item_id
      }
      item_id += rand(1..(how_many[:user] * how_many[:items_per_user] / how_many[:favorites_per_user]))

      if direct_sql_inject
        favorite_vals[:created_at]      = NOW_STR
        favorite_vals[:updated_at]      = NOW_STR

        vals = dict_to_db_str(favorite_vals, cols, val_delim)
        sql += i == 0 && user_id == 1 ? vals : ',' + vals
      else
        favorite_vals.delete(:id)
        Favorite.create!(favorite_vals)
      end
    end
  end

  if direct_sql_inject
    ActiveRecord::Base.connection.execute sql
  end
end

puts "Generated #{Favorite.count} favorites"

if Rails.env == 'production'
  ["users", "categories", "items", "rentals", "reviews", "favorites"].each do |table|
    ActiveRecord::Base.connection.execute "SELECT setval('#{table}_id_seq', (SELECT max(id) FROM #{table}))"
  end
end

# re-enable logger
if direct_sql_inject
  ActiveRecord::Base.logger.level = 0
end