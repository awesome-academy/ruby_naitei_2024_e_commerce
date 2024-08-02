class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :product

  delegate :image, :price, :name, :remain_quantity, to: :product
end
