class Product < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :category, optional: true
  has_one_attached :images
  scope :newest, ->{order(created_at: :desc)}
end
