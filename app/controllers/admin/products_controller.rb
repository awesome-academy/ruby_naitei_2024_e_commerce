class Admin::ProductsController < AdminController
  before_action :find_product, only: %i(edit update destroy)
  include Pagy::Backend

  def index
    @q = Product.ransack search_params
    @pagy, @products = pagy(@q.result(distinct: true).newest,
                            items: Settings.page_size)
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
    @product = Product.find params[:id]

    redirect_to admin_products_path unless @product
  end

  def product_params
    params.require(:product).permit(Product::PERMITTED_ATTRIBUTES)
  end

  def search_params
    q_params = params[:q] || {}
    q_params[:price_gteq] = sanitize_price q_params[:price_gteq]
    q_params[:price_lteq] = sanitize_price q_params[:price_lteq]
    q_params[:created_at_gteq] = parse_date q_params[:created_at_gteq]
    q_params[:created_at_lteq] = parse_date q_params[:created_at_lteq]
    q_params
  end

  def parse_date date_string
    Date.parse date_string
  rescue StandardError
    nil
  end

  def sanitize_price price
    price.to_f >= 0 ? price : nil
  end
end
