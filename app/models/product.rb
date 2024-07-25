class Product < ApplicationRecord
  acts_as_paranoid
  has_many :comments, dependent: :destroy
  belongs_to :category, optional: true
  has_one_attached :image
  scope :newest, ->{order(created_at: :desc)}
  delegate :name, to: :category, prefix: true
end
