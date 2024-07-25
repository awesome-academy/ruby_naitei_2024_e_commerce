class Cart < ApplicationRecord
  belongs_to :user
  has_many :carts_details, dependent: :destroy
  has_many :products, through: :carts_details
end
