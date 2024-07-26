class Product < ApplicationRecord
  acts_as_paranoid
  PERMITTED_ATTRIBUTES = [:name, :description, :price,
                          :remain_quantity, :image, :category_id].freeze

  has_many :comments, dependent: :destroy
  belongs_to :category, optional: true
  has_one_attached :image
  scope :newest, ->{order(created_at: :desc)}
  delegate :name, to: :category, prefix: true

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :remain_quantity, presence: true,
                              numericality: {only_integer: true,
                                             greater_than_or_equal_to: 0}
  validates :category_id,
            presence: true
  validates :image, attached: true,
                    content_type: ["image/png", "image/jpg", "image/jpeg"],
                    size: {less_than: 5.megabytes}
end
