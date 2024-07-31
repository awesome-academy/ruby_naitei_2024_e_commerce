class CartController < ApplicationController
  before_action :logged_in_user
  before_action :find_product, only: :create
  before_action :load_current_user_cart

  def create
    quantity = params[:quantity].to_i
    handle_add_failed and return unless check_quantity quantity

    current_cart_detail = @cart_details.find_by(product_id: @product.id)
    if current_cart_detail
      new_quantity = current_cart_detail.quantity + quantity
      current_cart_detail.update(quantity: new_quantity)
    else
      @cart_details.create(product: @product, quantity:)
    end
    handle_add_success
  end

  def check_remain_and_redirect
    if check_remain_availability
      redirect_to new_bill_path
    else
      flash[:danger] = t "cart.quantity_greater_than_remain"
      redirect_to cart_path
    end
  end

  def show
    @cart_details = @cart.cart_details
  end

  private

  def find_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.is_nil"
    redirect_to root_path
  end

  def check_quantity quantity
    return false if quantity <= Settings.digit_0

    true
  end

  def handle_add_success
    flash[:success] = t "cart.add_success"
    redirect_to cart_path
  end

  def handle_add_failed
    flash[:danger] = t "cart.add_failed"
    redirect_to cart_path
  end

  def check_remain_availability
    @cart_details.none? do |cart_detail|
      cart_detail.quantity > cart_detail.product.remain_quantity
    end
  end
end
