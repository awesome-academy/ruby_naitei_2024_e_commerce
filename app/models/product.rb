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
  scope :product_by_comments, ->{joins(:comments).group("products.id")}

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

  ransacker :name_or_description do
    Arel::Nodes::Grouping.new(
      Arel::Nodes::Or.new(
        Arel::Nodes::NamedFunction.new("CONCAT",
                                       [table[:name], table[:description]])
      )
    )
  end

  scope :search_product, lambda {|search|
    search&.squish! if search
    ransack(name_or_description_cont: search).result
  }
  scope :filter_by_category_ids, lambda {|category_ids|
    return if category_ids.blank?

    ransack(category_id_in: category_ids).result
  }
  scope :filter_by_price, lambda {|from, to|
    return if from.blank? && to.blank?

    ransack(price_gteq: from).result.ransack(price_lteq: to).result
  }

  ransacker :created_at do
    Arel.sql("DATE(created_at)")
  end

  def self.ransackable_attributes _auth_object = nil
    %w(category_id created_at deleted_at description id name
price remain_quantity sales_count updated_at)
  end
end
