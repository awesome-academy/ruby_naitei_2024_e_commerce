class Comment < ApplicationRecord
  PERMITTED_ATTRIBUTES = %i(user_id product_id content star
                                      bill_detail_id).freeze
  belongs_to :product, optional: true
  belongs_to :billdetail, optional: true
  belongs_to :user, optional: true
  belongs_to :parent_comment, class_name: Comment.name, optional: true
  has_many :replies, class_name: Comment.name,
            foreign_key: :parent_comment_id, dependent: :destroy
  scope :five_stars_comments, ->{where(star: Settings.max_rating_star)}
end
