class Category < ApplicationRecord
  acts_as_paranoid
  has_many :products, dependent: :destroy
  belongs_to :parent_category, class_name: Category.name, optional: true
  has_many :child_categories, class_name: Category.name,
            foreign_key: :parent_category_id, dependent: :destroy
  validates :name, presence: true
  validates :image,
            content_type: {in: Settings.image_format,
                           message: I18n.t("image.image_invalid_format")}
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.digit_160, Settings.digit_160]
  end
  scope :oldest, ->{order(parent_category_id: :asc, created_at: :asc)}
  scope :order_by_comment, ->{order("COUNT(comments.id) DESC")}
  scope :category_by_comments, (lambda do
    joins(products: :comments)
      .group("categories.id")
  end)
  has_one_attached :image
end
