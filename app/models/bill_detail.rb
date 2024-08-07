class BillDetail < ApplicationRecord
  belongs_to :product
  belongs_to :bill
  has_one :comment, dependent: :destroy
end
