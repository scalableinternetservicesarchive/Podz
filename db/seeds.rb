# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(display_name: "Kasper", email: "k@spe.r", password: "kasper", password_confirmation: "kasper")
User.create!(display_name: "Alex", email: "a@le.x", password: "kasper", password_confirmation: "kasper")
User.create!(display_name: "August", email: "a@ugus.t", password: "kasper", password_confirmation: "kasper")
User.create!(display_name: "Ryan", email: "r@ya.n", password: "kasper", password_confirmation: "kasper")

Category.create!(name: "Furniture", description: "Just some furniture")
Category.create!(name: "Vehicles", description: "Just some vehicles")
Category.create!(name: "Gear", description: "Just some gear")

Item.create!(title: "Bike", description: "Nice bike for rent",available: "true", category_id: "2", price_hourly_usd: "5", price_daily_usd: "30")
Item.create!(title: "Couch", description: "Nice couch for rent",available: "true", category_id: "1", price_hourly_usd: "2", price_daily_usd: "10")
Item.create!(title: "Table", description: "Nice table for rent",available: "true", category_id: "1", price_hourly_usd: "3", price_daily_usd: "15")

Review.create!(item_id: "1", title: "Positive", body: "This is a positive review", rating: "5", user_id: "1", anonymous: "false")
Review.create!(item_id: "1", title: "Negative", body: "This is a negative review", rating: "1", user_id: "2", anonymous: "false")
Review.create!(item_id: "3", title: "Positive", body: "This is a positive review", rating: "5", user_id: "1", anonymous: "false")
Review.create!(item_id: "3", title: "Negative", body: "This is a negative review", rating: "1", user_id: "2", anonymous: "false")
Review.create!(item_id: "2", title: "Negative", body: "This is a negative review", rating: "2", user_id: "1", anonymous: "true")
Review.create!(item_id: "1", title: "Negative", body: "This is a long negative review,
                                                      This is a long negative review,
                                                      This is a long negative review,
                                                      This is a long negative review,This is a long negative review,
                                                      This is a long negative review,
                                                      This is a long negative review,This is a long negative review,
                                                      This is a long negative review,
                                                      This is a long negative review,This is a long negative review,
                                                      This is a long negative review,
                                                      This is a long negative review,
                                                      This is a long negative review,
                                                      This is a long negative review,
                                                      This is a long negative review,
                                                      This is a long negative review", rating: "1", user_id: "4", anonymous: "false")
