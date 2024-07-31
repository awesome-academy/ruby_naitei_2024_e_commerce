class Cart < ApplicationRecord
  before_save :init_total
  belongs_to :user
  has_many :cart_details, dependent: :destroy
  has_many :products, through: :cart_details

  def total
    @total = cart_details.map do |cart_detail|
      if cart_detail.valid?
        cart_detail.unit_price * cart_detail.quantity
      else
        Settings.digit_0
      end
    end
    @total.sum
  end

  private

  def init_total
    self[:total] = total
  end
end
