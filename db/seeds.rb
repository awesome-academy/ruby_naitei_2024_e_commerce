# Seed data User
User.create!(email: "admin@ecommerce.org",
             name: "Admin",
             gender: 1,
             admin: true,
             password: "admin123",
             password_confirmation: "admin123")

30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@ecommerce.org"
  password = "password"
  gender = Random.rand(0..2)
  User.create!(email: email,
               name: name,
               gender: gender,
               password: password,
               password_confirmation: password)
end
