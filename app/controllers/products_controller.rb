class ProductsController < ApplicationController
  def index
    @pagy, @products = pagy Product.newest, limit: Settings.page_size
  end

  def show; end
end
