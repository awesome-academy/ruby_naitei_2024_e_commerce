class BillDetail < ApplicationRecord
  belongs_to :product
  belongs_to :bill
end
