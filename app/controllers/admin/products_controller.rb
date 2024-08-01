class Admin::ProductsController < AdminController
  include Pagy::Backend
  def index
    @pagy, @products = pagy(Product.newest, items: Settings.page_size)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    @product.image.attach(params.dig(:product, :image))

    if @product.save
      flash[:success] = t("admin.products.create.success")
      redirect_to admin_products_path
    else
      flash.now[:danger] = t("admin.products.create.fail")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(Product::PERMITTED_ATTRIBUTES)
  end
end
