class Voucher < ApplicationRecord
  has_many :bills, dependent: :destroy
end
