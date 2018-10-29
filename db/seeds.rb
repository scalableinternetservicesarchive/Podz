# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_user = User.create(display_name:  "Admin User",
                   email: "admin@example.com",
                   password:              "foobar",
                   password_confirmation: "foobar",
                   admin: true,
                   biography: Faker::Lorem.sentences(15).join(" "))

normal_user = User.create(display_name:  "Normal User",
                   email: "normal@example.com",
                   password:              "foobar",
                   password_confirmation: "foobar",
                   admin: false,
                   biography: Faker::Lorem.sentences(15).join(" "))

10.times do |n|
  name = Faker::Book.genre
  description = Faker::Lorem::sentences(5).join(" ")
  Category.create!(name: name, description: description)
end

8.times do |m|
  # Creating fake item for admin user
  item_title = m % 2 == 0? Faker::LordOfTheRings.character : Faker::Beer.name
  item_description = Faker::Lorem.sentences(5).join(" ")
  Item.create(title: item_title,
              description: item_description,
              user_id: admin_user.id,
              category_id: m + 1,
              available: true,
              latitude: 34.41333 + rand(1..3)**(-(rand(1..2))),
              longitude: -119.86097 + rand(1..3)**(-rand(1..2)),
              price_hourly_usd: rand(0..50))
end

8.times do |m|
  # Creating fake item for normal user
  item_title = m % 2 == 0? Faker::LordOfTheRings.character : Faker::Beer.name
  item_description = Faker::Lorem.sentences(5).join(" ")
  Item.create(title: item_title,
              description: item_description,
              user_id: normal_user.id,
              category_id: m + 1,
              available: true,
              latitude: 34.41333 + rand(1..3)**(-(rand(1..2))),
              longitude: -119.86097 + rand(1..3)**(-rand(1..2)),
              price_hourly_usd: rand(0..50))
end

60.times do |n|
  # Creating fake user
  display_name  = Faker::Name.name
  email = Faker::Internet.email(name=display_name)
  password = "password"
  user = User.create(display_name:  display_name,
                     email: email,
                     password:              password,
                     password_confirmation: password,
                     biography: Faker::Lorem.sentences(15).join(" "))

  8.times do |m|
    # Creating fake item
    item_title = m % 2 == 0? Faker::Book.title : Faker::Beer.name
    item_description = Faker::Lorem.sentences(5).join(" ")
    Item.create!(title: item_title,
                 description: item_description,
                 user_id: user.id,
                 category_id: m + 1,
                 available: true,
                 latitude: 34.41333 + rand(1..3)**(-(rand(1..2))),
                 longitude: -119.86097 + rand(1..3)**(-rand(1..2)),
                 price_hourly_usd: rand(0..50))
  end
end

# Renting/checking in random items
3.times do |n|
  items = Item.where(available: true)
  item_index = 0

  User.all.each do |user|
    # Renting out a couple of items
    rand(2..5).times do |m|
      item = items[item_index]
      item_index += 1
      item.update(available: false)
      Rental.create(user_id: user.id, item_id: item.id)
    end

    # Checking in a couple of items
    rentals = Rental.where(user_id: user.id)
    unless Rental.where(user_id: user.id).count == 0
      rand(0..[rentals.count - 2, 0].max).times do |m|
        rental = rentals[m]
        item = Item.find(rental.item_id)
        rental.update(check_in_date: DateTime.now, history: true)
        item.update(available: true)
        Review.create!(title: Faker::Lorem.words(5).join(" "),
                       item_id: item.id,
                       body: Faker::Lorem.sentences(rand(1..5)).join(" "),
                       user_id: user.id,
                       rating: rand(1..5),
                       anonymous: rand(1..5) == 1)
      end
    end
  end
end
