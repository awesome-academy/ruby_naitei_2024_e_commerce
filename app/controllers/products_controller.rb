class ProductsController < ApplicationController
  def index
    @pagy, @products = pagy Product.newest, limit: Settings.page_size
  end

  def show
    @product = Product.includes(comments: :user).find_by(id: params[:id])
    unless @product
      flash[:alert] = t "errors.product.not_found"
      redirect_to root_path and return
    end
    @comments = @product.comments
  end
end
