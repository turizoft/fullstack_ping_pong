# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Simple seed for users, just for this exercise
(1..20).each do
  User.create(username: Faker::Internet.unique.user_name(separators: []), email: Faker::Internet.unique.email, password: '123456')
end