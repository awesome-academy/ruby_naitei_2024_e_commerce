class Category < ApplicationRecord
  acts_as_paranoid
  has_many :products, dependent: :destroy
  belongs_to :parent_category, class_name: Category.name, optional: true
  has_many :child_categories, class_name: Category.name,
            foreign_key: :parent_category_id, dependent: :destroy
  validates :name, presence: true
  has_one_attached :image
  scope :oldest, ->{order(parent_category_id: :asc, created_at: :asc)}
end
