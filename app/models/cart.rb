class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_details, dependent: :destroy
  has_many :products, through: :cart_details
end
