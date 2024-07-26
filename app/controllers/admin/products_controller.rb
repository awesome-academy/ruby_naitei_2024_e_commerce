class Admin::ProductsController < AdminController
  before_action :find_product, only: %i(edit update destroy)
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
      flash[:success] = t "admin.products.create.success"
      redirect_to admin_products_path
    else
      flash.now[:danger] = t "admin.products.create.fail"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update product_params
      flash[:success] = t "admin.products.edit.success"
      redirect_to admin_products_path
    else
      flash.now[:danger] = t "admin.products.edit.fail"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t "admin.products.destroy.success"
    else
      flash.now[:danger] = t "admin.products.destroy.fail"
    end
    redirect_to admin_products_path
  end

  private

  def find_product
    @product = Product.find(params[:id])

    redirect_to admin_products_path unless @product
  end

  def product_params
    params.require(:product).permit(Product::PERMITTED_ATTRIBUTES)
  end
end
