# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Category.create!(name: "Furniture", description: "Just some furniture")
Category.create!(name: "Vehicles", description: "Just some vehicles")
Category.create!(name: "Gear", description: "Just some gear")

Item.create!(title: "Bike", description: "Nice bike for rent", category_id: "2", price_hourly_usd: "5", price_daily_usd: "30")