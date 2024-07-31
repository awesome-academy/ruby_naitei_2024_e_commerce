class CartController < ApplicationController
  before_action :logged_in_user
  before_action :find_product, only: %i(create update)
  before_action :load_current_user_cart
  before_action :find_current_cart_detail, only: :update

  def create
    quantity = params[:quantity].to_i
    handle_add_failed and return unless check_quantity quantity

    current_cart_detail = @cart_details.find_by(product_id: @product.id)
    if current_cart_detail
      handle_add_failed and return unless
      check_remain current_cart_detail.remain_quantity, quantity

      new_quantity = current_cart_detail.quantity + quantity
      current_cart_detail.update(quantity: new_quantity)
    else
      @cart_details.create(product: @product, quantity:)
    end
    handle_add_success
  end

  def update
    quantity = params[:quantity].to_i
    handle_update_failed and return unless
    check_remain @current_cart_detail.remain_quantity, quantity

    handle_update_success @current_cart_detail, quantity
  end

  def check_remain_and_redirect
    if check_remain_availability
      redirect_to new_bill_path
    else
      flash[:danger] = t "cart.quantity_greater_than_remain"
      redirect_to cart_path(current_user)
    end
  end

  def show; end

  private

  def find_product
    @product = Product.find_by id: params[:product_id]
    return if @product

    flash[:danger] = t "product.is_nil"
    redirect_to root_path
  end

  def find_current_cart_detail
    @current_cart_detail = @cart_details.find_by(product_id: @product.id)
    return if @current_cart_detail

    flash[:danger] = t "cart_detail.is_nil"
    redirect_to root_path
  end

  def check_quantity quantity
    quantity > Settings.digit_0
  end

  def handle_add_success
    flash[:success] = t "cart.add_success"
    redirect_to cart_path(current_user)
  end

  def handle_add_failed
    flash[:danger] = t "cart.add_failed"
    redirect_to root_path
  end

  def check_remain_availability
    @cart_details.none? do |cart_detail|
      cart_detail.quantity > cart_detail.remain_quantity
    end
  end

  def check_remain remain, quantity
    quantity < remain
  end

  def handle_update_success current_cart_detail, quantity
    if check_quantity quantity
      current_cart_detail.update(quantity:)
    else
      current_cart_detail.destroy
    end
    flash[:success] = t "cart.update_success"
    redirect_to cart_path(current_user)
  end

  def handle_update_failed
    flash[:danger] = t "cart.update_failed"
    redirect_to cart_path(current_user)
  end
end
