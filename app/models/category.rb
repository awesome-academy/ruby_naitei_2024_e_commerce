class Category < ApplicationRecord
  has_many :products, optional: true, dependent: :destroy
  belongs_to :parent_category, class_name: Category.name, optional: true
  has_many :child_categories, class_name: Category.name,
            foreign_key: :parent_category_id, dependent: :destroy
end
