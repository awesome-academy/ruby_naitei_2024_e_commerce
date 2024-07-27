class StaticPagesController < ApplicationController
  def home
    @top_categories = Category.category_by_comments.order_by_comment
                              .limit(Settings.homepage_popular_category_size)
    @top_products = Product.product_by_comments.order_by_comment
                           .limit(Settings.homepage_popular_product_size)
    @top_comments = Comment.includes(:user).five_stars_comments
                           .limit(Settings.homepage_comments)
  end
end
