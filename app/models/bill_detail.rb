class BillDetail < ApplicationRecord
  belongs_to :product
  belongs_to :bill
  has_one :comment, dependent: :destroy

  delegate :image, :name, :price, to: :product, prefix: true
end
