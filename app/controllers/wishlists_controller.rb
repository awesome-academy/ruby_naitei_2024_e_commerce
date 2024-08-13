class WishlistsController < ApplicationController
  before_action :load_product, :user_signed_in?, only: %i(create destroy)
  def index
    @wishlists = current_user.wishlists
  end

  def create
    current_user.like(@product)

    respond_to do |format|
      format.html do
        redirect_to @product,
                    notice: t("wishlist.liked")
      end
      format.turbo_stream
    end
  end

  def destroy
    current_user.unlike(@product)

    respond_to do |format|
      format.html do
        redirect_to @product,
                    notice: t("wishlist.unlike")
      end
      format.turbo_stream
    end
  end

  private

  def load_product
    @product = Product.find_by id: params[:product_id]
    return if @product

    flash[:danger] = t "errors.not_found"
    redirect_to root_url
  end
end
