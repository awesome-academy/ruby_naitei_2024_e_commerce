# Seed data User
admin = User.create!(email: "admin@ecommerce.org",
                     name: "Admin",
                     gender: 1,
                     admin: true,
                     activated: true,
                     password: "admin1234",
                     password_confirmation: "admin1234",
                     activated_at: Time.zone.now)
admin.avatar.attach(io: File.open(Rails.root.join("./app/assets/images", "admin.png")), filename: "admin.png")

30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@ecommerce.org"
  password = "password123"
  gender = Random.rand(0..2)
  user = User.create!(email: email,
                      name: name,
                      activated: true,
                      gender: gender,
                      password: password,
                      password_confirmation: password,
                      activated_at: Time.zone.now)
  user.avatar.attach(io: File.open(Rails.root.join("./app/assets/images", "user.png")), filename: "user.png")
end

# Seed categories
10.times do
  parent_cate = Category.create!(name: "Parent category", parent_category_id: nil)
  parent_cate.image.attach(io: File.open(Rails.root.join("./app/assets/images", "parent-cate.png")), filename: "parent-cate.png")
end

10.times do |n|
  child_cate = Category.create!(name: "Child category", parent_category_id: Category.find(n+1).id)
  child_cate.image.attach(io: File.open(Rails.root.join("./app/assets/images", "child-cate.jpeg")), filename: "child-cate.jpeg")
end

# Seed products
10.times do
  prod1 = Product.create!(name: "Iphone",
                          price: 30000000,
                          remain_quantity: 20,
                          description: "Iphone",
                          category_id: Category.first.id)

  prod1.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod1.jpg")), filename: "prod1.jpg")
end

10.times do
  prod1 = Product.create!(name: "Iphone",
                          price: 30000000,
                          remain_quantity: 20,
                          description: "Iphone",
                          category_id: Category.find(2).id)

  prod1.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod1.jpg")), filename: "prod1.jpg")
end

10.times do
  prod1 = Product.create!(name: "Iphone",
                          price: 30000000,
                          remain_quantity: 20,
                          description: "Iphone",
                          category_id: Category.find(3).id)

  prod1.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod1.jpg")), filename: "prod1.jpg")
end

10.times do
  prod2 = Product.create!(name: "Áo thun",
                          price: 200000,
                          remain_quantity: 2000,
                          description: "Áo thun",
                          category_id: Category.find(4).id)

  prod2.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod2.webp")), filename: "prod2.webp")
end

10.times do
  prod2 = Product.create!(name: "Áo thun",
                          price: 200000,
                          remain_quantity: 2000,
                          description: "Áo thun",
                          category_id: Category.find(5).id)

  prod2.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod2.webp")), filename: "prod2.webp")
end

10.times do
  prod2 = Product.create!(name: "Áo thun",
                          price: 200000,
                          remain_quantity: 2000,
                          description: "Áo thun",
                          category_id: Category.find(6).id)

  prod2.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod2.webp")), filename: "prod2.webp")
end

10.times do
  prod3 = Product.create!(name: "Giày tây",
                          price: 3000000,
                          remain_quantity: 30,
                          description: "Giày tây",
                          category_id: Category.find(7).id)

  prod3.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod3.jpg")), filename: "prod3.jpg")
end

10.times do
  prod3 = Product.create!(name: "Giày tây",
                          price: 3000000,
                          remain_quantity: 30,
                          description: "Giày tây",
                          category_id: Category.find(8).id)

  prod3.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod3.jpg")), filename: "prod3.jpg")
end

10.times do
  prod3 = Product.create!(name: "Giày tây",
                          price: 3000000,
                          remain_quantity: 30,
                          description: "Giày tây",
                          category_id: Category.find(9).id)

  prod3.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod3.jpg")), filename: "prod3.jpg")
end

10.times do
  prod4 = Product.create!(name: "Bánh",
                          price: 10000,
                          remain_quantity: 500,
                          description: "Bánh",
                          category_id: Category.find(10).id)

  prod4.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod4.jpg")), filename: "prod4.jpg")
end

10.times do
  prod4 = Product.create!(name: "Bánh",
                          price: 10000,
                          remain_quantity: 500,
                          description: "Bánh",
                          category_id: Category.find(11).id)

  prod4.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod4.jpg")), filename: "prod4.jpg")
end

10.times do
  prod4 = Product.create!(name: "Bánh",
                          price: 10000,
                          remain_quantity: 500,
                          description: "Bánh",
                          category_id: Category.find(12).id)

  prod4.image.attach(io: File.open(Rails.root.join("./app/assets/images", "prod4.jpg")), filename: "prod4.jpg")
end

#Seed comments
for a in 1..100 do
  5.times do |n|
    Comment.create!(user_id: User.find(n+2).id,
                    product_id: a,
                    content: "Sản phẩm chất lượng",
                    parent_comment_id: nil,
                    star: 5)
  end
end

5.times do |n|
  Comment.create!(user_id: 1,
                  product_id: 1,
                  content: "Thank you",
                  parent_comment_id: User.find(n+1).id,
                  star: nil)
end

#Seed vouchers
day_now = DateTime.now
voucher1 = Voucher.create!(name: "GIANGSINH",
                           condition: 100000,
                           discount: 0.1,
                           started_at: day_now,
                           ended_at: day_now + 1.month)

voucher2 = Voucher.create!(name: "NAMMOI",
                           condition: 200000,
                           discount: 0.2,
                           started_at: day_now,
                           ended_at: day_now + 1.month)

voucher3 = Voucher.create!(name: "TETDENROI",
                           condition: 500000,
                           discount: 0.3,
                           started_at: day_now,
                           ended_at: day_now + 1.month)

#Seed bills
bill1 = Bill.create!(user_id: 2,
                     address: "TP.HCM",
                     phone_number: "0123456789",
                     voucher_id: 3,
                     status: 3,
                     note_content: "abc",
                     total: 30000000,
                     total_after_discount: 21000000,
                     expired_at: nil)

bill2 = Bill.create!(user_id: 2,
                     address: "TP.HCM",
                     phone_number: "0123456789",
                     voucher_id: 1,
                     status: 3,
                     note_content: "abc",
                     total: 3020000,
                     total_after_discount: 2718000,
                     expired_at: nil)

#Seed bill details
BillDetail.create!(bill_id: 1,
                   product_id: 1,
                   quantity: 1)

BillDetail.create!(bill_id: 2,
                   product_id: 3,
                   quantity: 1)

BillDetail.create!(bill_id: 2,
                   product_id: 4,
                   quantity: 1)

#Seed wishlist
Wishlist.create!(user_id: 3,
                 product_id: 1)

Wishlist.create!(user_id: 3,
                 product_id: 2)

Wishlist.create!(user_id: 4,
                 product_id: 2)

Wishlist.create!(user_id: 4,
                 product_id: 3)

Wishlist.create!(user_id: 4,
                 product_id: 4)


Cart.create!(user_id: 2, total: 30020000)

CartDetail.create!(cart_id: 1, product_id: 1, quantity: 1, total: 30000000)
CartDetail.create!(cart_id: 1, product_id: 120, quantity: 2, total: 20000)
