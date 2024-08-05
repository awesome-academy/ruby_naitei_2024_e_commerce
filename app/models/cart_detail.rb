class CartDetail < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  delegate :image, :price, :name, :remain_quantity, to: :product
end
