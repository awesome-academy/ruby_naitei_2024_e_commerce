class Product < ApplicationRecord
  acts_as_paranoid
  PERMITTED_ATTRIBUTES = %i(name description price remain_quantity image
                            category_id).freeze

  has_many :comments, dependent: :destroy
  has_many :cart_details, dependent: :destroy
  belongs_to :category, optional: true
  has_one_attached :image
  scope :newest, ->{order(created_at: :desc)}
  delegate :name, to: :category, prefix: true
  scope :order_by_comment, ->{order("COUNT(comments.id) DESC")}
  scope :product_by_comments, (lambda do
    joins(:comments)
      .group("products.id")
  end)

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true,
                    numericality: {greater_than: Settings.digit_0}
  validates :remain_quantity, presence: true,
                              numericality: {
                                only_integer: true,
                                greater_than_or_equal_to: Settings.digit_0
                              }
  validates :category_id, presence: true
  validates :image,
            content_type: Settings.image_format,
            size: {less_than: Settings.max_image_data.megabytes}
end
