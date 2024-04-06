# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
  
10.times do
  name = Faker::Creature::Animal.name
  email = Faker::Internet.email
  password = "password"
  profile_image = Faker::LoremFlickr.image(size: "50x50", is_gray: false)
  user = User.new(name: name, email: email, password: password, password_confirmation: password)
  user.profile_image.attach(io: URI.open(profile_image), filename: 'profile_image.jpg')
  user.save!
end

20.times do
  user_id = rand(1..7)
  title = Faker::Book.title
  body = Faker::Lorem.sentence
  Book.create!(user_id: user_id, title: title, body: body)
end