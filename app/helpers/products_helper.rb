module ProductsHelper
  def average_of_rating comments
    comment_users = comment_users comments
    return if comment_users.blank?

    stars = comment_users.map(&:star)
    (stars.sum.to_f / stars.size).ceil
  end

  def comment_users comments
    comments&.select{|comment| comment.star.present?}
  end

  def check_remain wishlist
    wishlist.remain_quantity > Settings.digit_0
  end
end
