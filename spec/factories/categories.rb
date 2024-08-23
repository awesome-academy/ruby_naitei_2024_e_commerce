require "faker"

FactoryBot.define do
  factory :category do
    name { Faker::Food.ethnic_category }
    after(:build) do |category|
      category.image.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "category.png")),
        filename: "category.png",
        content_type: "image/png"
      )
    end
  end

  factory :comment do
    bill_detail_id { nil }
    user_id { nil }
    product_id { create(:product) }
    content { Faker::Lorem.paragraph }
    parent_comment_id { nil }
    star { rand(1..5) }
  end
end
