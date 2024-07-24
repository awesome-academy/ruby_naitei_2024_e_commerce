class Voucher < ApplicationRecord
  has_many :bills, optional: true, dependent: :destroy
end
