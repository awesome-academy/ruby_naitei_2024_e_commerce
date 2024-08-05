class CartDetail < ApplicationRecord
  before_save :init_unit_price
  before_save :init_total

  belongs_to :cart
  belongs_to :product

  delegate :image, :price, :name, :remain_quantity, to: :product

  def unit_price
    if persisted?
      self[:unit_price]
    else
      product.price
    end
  end

  private

  def init_unit_price
    self[:unit_price] = unit_price
  end

  def init_total
    self[:total] = unit_price * quantity
  end
end
