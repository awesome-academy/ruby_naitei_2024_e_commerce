# Seed data User
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@ecommerce.org"
  password = "password123"
  gender = Random.rand(0..2)
  user = User.new(email: email,
                      name: name,
                      activated: true,
                      gender: gender,
                      password: password,
                      password_confirmation: password,
                      activated_at: Time.zone.now)
  user.save!
  user.avatar.attach(io: File.open(Rails.root.join("./app/assets/images", "user.png")), filename: "user.png")
end




# Seed products
admin = User.new(email: "admin@ecommerce.org",
                     name: "Admin",
                     gender: 1,
                     admin: true,
                     activated: true,
                     password: "admin1234",
                     password_confirmation: "admin1234",
                     activated_at: Time.zone.now)
admin.save!
admin.avatar.attach(io: File.open(Rails.root.join("./app/assets/images", "admin.png")), filename: "admin.png")

# Seed categories
do_dien_tu = Category.create!(name: "Đồ điện tử", parent_category_id: nil)
do_dien_tu.image.attach(io: File.open(Rails.root.join("./app/assets/images", "do-dien-tu.jpg")), filename: "do-dien-tu.jpg")

smartphone = Category.create!(name: "Smartphone", parent_category_id: do_dien_tu.id)
smartphone.image.attach(io: File.open(Rails.root.join("./app/assets/images", "smartphone.jpg")), filename: "smartphone.jpg")

laptop = Category.create!(name: "Laptop", parent_category_id: do_dien_tu.id)
laptop.image.attach(io: File.open(Rails.root.join("./app/assets/images", "laptop.jpg")), filename: "laptop.jpg")

do_gia_dung = Category.create!(name: "Đồ gia dụng", parent_category_id: nil)
do_gia_dung.image.attach(io: File.open(Rails.root.join("./app/assets/images", "do-gia-dung.png")), filename: "do-gia-dung.png")

noi = Category.create!(name: "Nồi", parent_category_id: do_gia_dung.id)
noi.image.attach(io: File.open(Rails.root.join("./app/assets/images", "noi.jpg")), filename: "noi.jpg")

chao = Category.create!(name: "Chảo", parent_category_id: do_gia_dung.id)
chao.image.attach(io: File.open(Rails.root.join("./app/assets/images", "chao.jpeg")), filename: "chao.jpeg")

# Seed products
prod1 = Product.create!(name: "Iphone 15 promax",
                        price: 30000000,
                        remain_quantity: 20,
                        description: "Iphone 15 promax",
                        sales_count: 20,
                        category_id: smartphone.id)
prod1.image.attach(io: File.open(Rails.root.join("./app/assets/images", "iphone.jpg")), filename: "iphone.jpg")

prod2 = Product.create!(name: "Samsung Galaxy S24 Ultra 12GB 256GB",
                        price: 29990000,
                        remain_quantity: 150,
                        description: "Samsung Galaxy S24 Ultra 12GB 256GB",
                        category_id: smartphone.id)
prod2.image.attach(io: File.open(Rails.root.join("./app/assets/images", "samsung.jpg")), filename: "samsung.jpg")

prod3 = Product.create!(name: "Xiaomi Redmi Note 12 (8GB+128GB)",
                        price: 3890000,
                        remain_quantity: 354,
                        description: "Xiaomi Redmi Note 12 (8GB+128GB)",
                        sales_count: 10,
                        category_id: smartphone.id)
prod3.image.attach(io: File.open(Rails.root.join("./app/assets/images", "xiaomi.jpg")), filename: "xiaomi.jpg")

prod4 = Product.create!(name: "Laptop Dell Inspiron 15 3530 i7",
                        price: 23990000,
                        remain_quantity: 200,
                        description: "Laptop Dell Inspiron 15 3530 i7",
                        sales_count: 200,
                        category_id: laptop.id)
prod4.image.attach(io: File.open(Rails.root.join("./app/assets/images", "dell.jpg")), filename: "dell.jpg")

prod5 = Product.create!(name: "Laptop Asus X1502ZA-BQ127W Xanh",
                        price: 12990000,
                        remain_quantity: 107,
                        description: "Laptop Asus X1502ZA-BQ127W Xanh",
                        category_id: laptop.id)
prod5.image.attach(io: File.open(Rails.root.join("./app/assets/images", "asus.jpg")), filename: "asus.jpg")

prod6 = Product.create!(name: "Nồi chiên không dầu rapido giá rẻ, chính hãng",
                        price: 1090000,
                        remain_quantity: 22,
                        description: "Nồi chiên không dầu rapido giá rẻ, chính hãng",
                        category_id: noi.id)
prod6.image.attach(io: File.open(Rails.root.join("./app/assets/images", "noi-chien.jpg")), filename: "noi-chien.jpg")

prod7 = Product.create!(name: "Nồi cơm điện Nagakawa NAG0146",
                        price: 1200000,
                        remain_quantity: 86,
                        description: "Nồi cơm điện Nagakawa NAG0146",
                        sales_count: 10,
                        category_id: noi.id)
prod7.image.attach(io: File.open(Rails.root.join("./app/assets/images", "noi-com.jpg")), filename: "noi-com.jpg")

prod8 = Product.create!(name: "Nồi áp suất điện Philips HD2103/66 5 lít",
                        price: 1590000,
                        remain_quantity: 70,
                        description: "Nồi áp suất điện Philips HD2103/66 5 lít",
                        category_id: noi.id)
prod8.image.attach(io: File.open(Rails.root.join("./app/assets/images", "noi-ap-suat.jpg")), filename: "noi-ap-suat.jpg")

prod9 = Product.create!(name: "Chảo Chống Dính Đáy Từ Sunhouse SHM20MB",
                        price: 119000,
                        remain_quantity: 55,
                        description: "Chảo Chống Dính Đáy Từ Sunhouse SHM20MB",
                        category_id: chao.id)
prod9.image.attach(io: File.open(Rails.root.join("./app/assets/images", "chao-chong-dinh.jpg")), filename: "chao-chong-dinh.jpg")

prod10 = Product.create!(name: "Chảo Sâu Lòng Vân Đá Đáy Từ Ecoramic Size 32 – ECORAMIC",
                        price: 500000,
                        remain_quantity: 20,
                        description: "Chảo Sâu Lòng Vân Đá Đáy Từ Ecoramic Size 32 – ECORAMIC",
                        category_id: chao.id)
prod10.image.attach(io: File.open(Rails.root.join("./app/assets/images", "chao-sau-long.jpg")), filename: "chao-sau-long.jpg")

#Seed comments
for a in 1..10 do
  10.times do |n|
    Comment.create!(user_id: User.find(n+2).id,
                    product_id: a,
                    content: "Sản phẩm chất lượng",
                    parent_comment_id: nil,
                    star: 5)
  end
end
#Seed comments
# for a in 1..100 do
#   5.times do |n|
#     Comment.create!(user_id: User.find(n+2).id,
#                     product_id: a,
#                     content: "Sản phẩm chất lượng",
#                     parent_comment_id: nil,
#                     star: 5)
#   end
# end

# 5.times do |n|
#   Comment.create!(user_id: 1,
#                   product_id: 1,
#                   content: "Thank you",
#                   parent_comment_id: User.find(n+1).id,
#                   star: nil)
# end



parent_cate = Category.create!(name: "Thời Trang Nam", parent_category_id: nil)
parent_cate.image.attach(io: File.open(Rails.root.join("./app/assets/images", "thoitrangnam.jpg")), filename: "thoitrangnam.jpg")

ao_khoac = Category.create!(name: "Áo Khoác", parent_category_id: 7)
ao_khoac.image.attach(io: File.open(Rails.root.join("./app/assets/images", "ao-khoac-gio-nam-den-chinh-hang.jpg")), filename: "ao-khoac-gio-nam-den-chinh-hang.jpg")

ao_vest = Category.create!(name: "Áo Vest và Blazer", parent_category_id: 7)
ao_vest.image.attach(io: File.open(Rails.root.join("./app/assets/images", "aovestvablazer.png")), filename: "aovestvablazer.png")

hoodie = Category.create!(name: "Áo Hoodie", parent_category_id: 7)
hoodie.image.attach(io: File.open(Rails.root.join("./app/assets/images", "aohoodie.png")), filename: "aohoodie.png")

names = [
  "Áo phông nam nữ Premium Cotton phối vải bò xanh nắp túi in vạch chữ Dsq2 cam sau lưng rẻ hot trend 2024",
  "Áo Nắng Nam Thông Hơi,Cạp To, Túi Có Khoá Kéo An Toàn",
  "Áo khoác dù nam cán 2 lớp phối nón có túi trong, túi ngoài có khóa kéo-4 màu 5 size"
]

descriptions = [
  "Áo phông cổ tròn nam nữ Unisex cotton ghép vải bò xanh nắp túi ngực phối in vạch chữ Dsq2 vàng sau lưng",
  "Áo chống nắng cho nam chất thông hơi, thoáng mát",
  "Thiết kế tinh tế nam tính, tay dài sành điệu, cá tính, form dáng khỏe khoắn cho bạn phong cách trẻ trung, chỉnh chu và không kém phần lịch lãm."
]

category_id = 8

names.each_with_index do |name, index|
  prod = Product.create!(
    name: name,
    price: rand(100000..500000),
    remain_quantity: rand(10..50),
    description: descriptions[index],
    category_id: category_id
  )

  # Convert product name to filename without diacritics and spaces
  filename = name.downcase
                   .gsub(/[áàảãạâấầẩẫậăắằẳẵặ]/, 'a')
                   .gsub(/[éèẻẽẹêếềểễệ]/, 'e')
                   .gsub(/[íìỉĩị]/, 'i')
                   .gsub(/[óòỏõọôốồổỗộơớờởỡợ]/, 'o')
                   .gsub(/[úùủũụưứừửữự]/, 'u')
                   .gsub(/[ýỳỷỹỵ]/, 'y')
                   .gsub(/đ/, 'd')
                   .gsub(/\s+/, '')

  prod.image.attach(io: File.open(Rails.root.join("./app/assets/images", "#{filename}.png")), filename: "#{filename}.png")
end

names = [
  "Áo Gile nam cao cấp Ghile KING 4 nút chất vải tây công sở cao cấp thiết kế sang trọng lịch lãm style Hàn Quốc Z10",
  "Áo gile nam nữ form rộng unisex (Có bigsize 2XL)",
  "Áo Vest va Blazer 1 lớp mỏng nhẹ oversize style vintage công sở Nhật Hàn"
]

descriptions = [
  "Áo gile nam Hàn quốc, là một phần không thể thiếu của bộ suit của đấm mày râu, ngoài ra các bạn có thể phối cùng chiếc áo sơ mi, cũng vô vùng đẹp",
  "Chất liệu: thun cotton - dày dặn và đứng form khi mặc",
  "Blazer nam / vest form nam nhưng các bạn nữ mặc oversize khoác ngoài siêu xinh lunn ý"
]

category_id = 9

names.each_with_index do |name, index|
  prod = Product.create!(
    name: name,
    price: rand(100000..500000),
    remain_quantity: rand(10..50),
    description: descriptions[index],
    category_id: category_id
  )

  # Convert product name to filename without diacritics and spaces
  filename = name.downcase
                   .gsub(/[áàảãạâấầẩẫậăắằẳẵặ]/, 'a')
                   .gsub(/[éèẻẽẹêếềểễệ]/, 'e')
                   .gsub(/[íìỉĩị]/, 'i')
                   .gsub(/[óòỏõọôốồổỗộơớờởỡợ]/, 'o')
                   .gsub(/[úùủũụưứừửữự]/, 'u')
                   .gsub(/[ýỳỷỹỵ]/, 'y')
                   .gsub(/đ/, 'd')
                   .gsub(/\s+/, '')

  prod.image.attach(io: File.open(Rails.root.join("./app/assets/images", "#{filename}.png")), filename: "#{filename}.png")
end


names = [
  "Áo KHOÁC Hoodie TRƠN SPEACE 4 Màu Nam Nữ Ulzzang Unisex",
  "Áo khoá nỉ mũ hai lớp logo WASK nỉ lót bông form thụng",
  "ÁO NỈ DÀI TAY NAM NỮ Y VÀ N PHONG CÁCH TRANG HÀN QUỐC CỰC ĐẸP",
  "Áo Hoodie Chữ Kí Form Rộng Unisex Mũ 2 lớp Cao Cấp Chất Liệu Nỉ Bông Cao Cấp"
]

descriptions = [
  "-Chất Liệu: Nỉ bông cao cấp giữ ấm, cách nhiệt cho cơ thể

-Đặc biệt có lớp bông mỏng nhẹ bên trong ,khả năng co giãn tốt giúp người mặc luôn cảm thấy thoải mái ạ!",
  "Áo chất nỉ bông các màu in logo WASK FORM dáng thụng

Sản xuất tại: phuongmyt

Freesize",
  "Thông Tin Sản Phẩm :
- Áo thiết kế form chui không có nón.",
"THÔNG TIN SẢN PHẨM:THÔNG TIN SẢN PHẨM: Áo nỉ Hoodie
- Chất liệu nỉ Bông   Cotton 100%  mềm mại dày dặn  , ấm áp"
]

category_id = 10

names.each_with_index do |name, index|
  prod = Product.create!(
    name: name,
    price: rand(100000..500000),
    remain_quantity: rand(10..50),
    description: descriptions[index],
    category_id: category_id
  )

  # Convert product name to filename without diacritics and spaces
  filename = name.downcase
                   .gsub(/[áàảãạâấầẩẫậăắằẳẵặ]/, 'a')
                   .gsub(/[éèẻẽẹêếềểễệ]/, 'e')
                   .gsub(/[íìỉĩị]/, 'i')
                   .gsub(/[óòỏõọôốồổỗộơớờởỡợ]/, 'o')
                   .gsub(/[úùủũụưứừửữự]/, 'u')
                   .gsub(/[ýỳỷỹỵ]/, 'y')
                   .gsub(/đ/, 'd')
                   .gsub(/\s+/, '')

  prod.image.attach(io: File.open(Rails.root.join("./app/assets/images", "#{filename}.png")), filename: "#{filename}.png")
end

# Array of comment contents
comment_contents = [
  "Sản phẩm này rất tốt, tôi rất hài lòng!",
  "Chất lượng vải rất đẹp, đáng mua!",
  "Áo mặc rất thoải mái và phong cách.",
  "Mình rất thích thiết kế của sản phẩm này.",
  "Giá cả hợp lý, sẽ ủng hộ shop dài dài.",
  "Dịch vụ chăm sóc khách hàng tuyệt vời.",
  "Mua về làm quà tặng, người nhận rất thích.",
  "Chất lượng vượt trội so với giá tiền.",
  "Màu sắc sản phẩm rất đẹp và bền.",
  "Đóng gói sản phẩm rất cẩn thận."
]

# Create 10 comments for each product by different users
Product.all.each do |product|
  10.times do
    user = User.order("RAND()").first # Select a random user using MySQL-compatible RAND()
    content = comment_contents.sample  # Select a random comment content
    product.comments.create!(content: content, user_id: user.id)
  end
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

# Seed bills
bill1 = Bill.create!(user_id: 2,
                     phone_number: "0123456789",
                     voucher_id: 3,
                     status: 1,
                     note_content: "abc",
                     total: 30000000,
                     total_after_discount: 21000000,
                     expired_at: nil)

bill2 = Bill.create!(user_id: 2,
                     phone_number: "0123456789",
                     voucher_id: 1,
                     status: 1,
                     note_content: "abc",
                     total: 27880000,
                     total_after_discount: 25092000,
                     expired_at: nil)

bill3 = Bill.create!(user_id: 3,
                     phone_number: "0123456789",
                     voucher_id: 3,
                     status: 3,
                     note_content: "abc",
                     total: 60000000,
                     total_after_discount: 42000000,
                     expired_at: nil,
                     created_at: day_now - 1.month)

bill4 = Bill.create!(user_id: 3,
                     phone_number: "0123456789",
                     voucher_id: 1,
                     status: 2,
                     note_content: "abc",
                     total: 51870000,
                     total_after_discount: 46683000,
                     expired_at: nil,
                     created_at: day_now - 1.month)

bill5 = Bill.create!(user_id: 4,
                     phone_number: "0123456789",
                     voucher_id: 3,
                     status: 3,
                     note_content: "abc",
                     total: 30000000,
                     total_after_discount: 21000000,
                     expired_at: nil,
                     created_at: day_now - 2.months)

bill6 = Bill.create!(user_id: 4,
                     phone_number: "0123456789",
                     voucher_id: 1,
                     status: 3,
                     note_content: "abc",
                     total: 27880000,
                     total_after_discount: 25092000,
                     expired_at: nil,
                     created_at: day_now - 2.months)

bill7 = Bill.create!(user_id: 5,
                     phone_number: "0123456789",
                     voucher_id: 3,
                     status: 3,
                     note_content: "abc",
                     total: 60000000,
                     total_after_discount: 42000000,
                     expired_at: nil,
                     created_at: day_now - 3.months)

bill8 = Bill.create!(user_id: 5,
                     phone_number: "0123456789",
                     voucher_id: 1,
                     status: 2,
                     note_content: "abc",
                     total: 51870000,
                     total_after_discount: 46683000,
                     expired_at: nil,
                     created_at: day_now - 3.months)


address = Address.create!(bill_id: 1, country: "AF", state: "GHA", city: "Ghazni", details: "123 Landmark")

address1 = Address.create!(bill_id: 2, country: "AF", state: "GHA", city: "Ghazni", details: "123 London")

address2 = Address.create!(bill_id: 3, country: "AF", state: "GHA", city: "Ghazni", details: "123 Landmark")

address3 = Address.create!(bill_id: 4, country: "AF", state: "GHA", city: "Ghazni", details: "123 London")

address4 = Address.create!(bill_id: 5, country: "AF", state: "GHA", city: "Ghazni", details: "123 Landmark")

address5 = Address.create!(bill_id: 6, country: "AF", state: "GHA", city: "Ghazni", details: "123 London")

address6 = Address.create!(bill_id: 7, country: "AF", state: "GHA", city: "Ghazni", details: "123 Landmark")

address7 = Address.create!(bill_id: 8, country: "AF", state: "GHA", city: "Ghazni", details: "123 London")

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

BillDetail.create!(bill_id: 3,
                   product_id: 1,
                   quantity: 2)

BillDetail.create!(bill_id: 4,
                   product_id: 3,
                   quantity: 1)

BillDetail.create!(bill_id: 4,
                   product_id: 4,
                   quantity: 2)

BillDetail.create!(bill_id: 5,
                   product_id: 1,
                   quantity: 1)

BillDetail.create!(bill_id: 6,
                   product_id: 3,
                   quantity: 1)

BillDetail.create!(bill_id: 6,
                   product_id: 4,
                   quantity: 1)

BillDetail.create!(bill_id: 7,
                   product_id: 1,
                   quantity: 2)

BillDetail.create!(bill_id: 8,
                   product_id: 3,
                   quantity: 1)

BillDetail.create!(bill_id: 8,
                   product_id: 4,
                   quantity: 2)

#Seed wishlist
Wishlist.create!(user_id: 2,
                product_id: 4)

Wishlist.create!(user_id: 2,
                 product_id: 2)


Wishlist.create!(user_id: 2,
                product_id: 3)

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

31.times do |n|
  Cart.create!(user_id: n + 1)
end
