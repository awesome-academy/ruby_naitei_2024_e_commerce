class Admin::ProductsController < AdminController
  include Pagy::Backend
  def index
    @pagy, @products = pagy(Product.newest, items: Settings.page_size)
  end
end
