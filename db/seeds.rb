# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(display_name:  "Admin User",
             email: "admin@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             biography: Faker::Lorem.sentences(6).join(" "))

User.create!(display_name:  "Normal User",
             email: "normal@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: false,
             biography: Faker::Lorem.sentences(6).join(" "))

10.times do |n|
  name = Faker::Book.genre
  description = Faker::Lorem::sentences(5).join(" ")
  Category.create!(name: name, description: description)
end

30.times do |n|
  display_name  = Faker::Name.name
  email = Faker::Internet.email(name=display_name)
  password = "password"
  user = User.create(display_name:  display_name,
                     email: email,
                     password:              password,
                     password_confirmation: password)
  6.times do |m|
    item_title = m % 2 == 0? Faker::Book.title : Faker::Beer.name
    item_description = Faker::Lorem.sentences(5).join(" ")
    item = Item.create(title: item_title,
                       description: item_description,
                       user_id: user.id,
                       category_id: m + 1,
                       available: true)
    rand(5..10).times do |k|
      Review.create!(title: Faker::Lorem.words(5).join(" "),
                     item_id: item.id,
                     body: Faker::Lorem.sentences(rand(1..5)).join(" "),
                     user_id: user.id,
                     rating: rand(1..5),
                     anonymous: rand(1..5) == 1)
    end
  end
end