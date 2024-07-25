# Seed data User
admin = User.create!(email: "admin@ecommerce.org",
                     name: "Admin",
                     gender: 1,
                     admin: true,
                     password: "admin123",
                     password_confirmation: "admin123")
admin.avatar.attach(io: File.open(Rails.root.join("./app/assets/images", "admin.png")), filename: "admin.png")

30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@ecommerce.org"
  password = "password"
  gender = Random.rand(0..2)
  user = User.create!(email: email,
                      name: name,
                      gender: gender,
                      password: password,
                      password_confirmation: password)
  user.avatar.attach(io: File.open(Rails.root.join("./app/assets/images", "user.png")), filename: "user.png")
end

# Seed categories
5.times do
  parent_cate = Category.create!(name: "Parent category", parent_category_id: nil)
  parent_cate.image.attach(io: File.open(Rails.root.join("./app/assets/images", "parent-cate.png")), filename: "parent-cate.png")
end

5.times do |n|
  child_cate = Category.create!(name: "Child category", parent_category_id: Category.find(n+1).id)
end

# Seed products
30.times do
  prod1 = Product.create!(name: "Iphone",
                          price: 30000000,
                          remain_quantity: 20,
                          description: "Iphone",
                          category_id: Category.first.id)

  prod1.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod1.jpg")), filename: "prod1.jpg")
end

30.times do
  prod2 = Product.create!(name: "Áo thun",
                          price: 200000,
                          remain_quantity: 2000,
                          description: "Áo thun",
                          category_id: Category.find(2).id)

  prod2.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod2.webp")), filename: "prod2.webp")
end

30.times do
  prod3 = Product.create!(name: "Giày tây",
                          price: 3000000,
                          remain_quantity: 30,
                          description: "Giày tây",
                          category_id: Category.find(3).id)

  prod3.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod3.jpg")), filename: "prod3.jpg")
end

30.times do
  prod4 = Product.create!(name: "Bánh",
                          price: 10000,
                          remain_quantity: 500,
                          description: "Bánh",
                          category_id: Category.find(4).id)

  prod4.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod4.jpg")), filename: "prod4.jpg")
end

#Seed comments
5.times do |n|
  Comment.create!(user_id: User.find(n+2).id,
                  product_id: 1,
                  content: "Sản phẩm chất lượng",
                  parent_comment_id: nil,
                  star: 5)
end

5.times do |n|
  Comment.create!(user_id: 1,
                  product_id: 1,
                  content: "Thank you!",
                  parent_comment_id: User.find(n+1).id,
                  star: nil)
end
