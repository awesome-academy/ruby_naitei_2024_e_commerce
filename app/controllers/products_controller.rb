class ProductsController < ApplicationController
  def index
    search_query = search_params ? search_params[:name_or_description] : nil
    @pagy, @products = pagy(Product.search_product(search_query).newest,
                            items: Settings.page_size)
  end

  def search_params
    return nil unless params[:product_list]

    params.require(:product_list).permit :name_or_description
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
