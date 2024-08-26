class Api::V1::CartController < ApplicationController
  before_action :authenticate_request_api, :load_current_user
  before_action :find_product_cart, only: %i(create update)
  before_action :find_current_cart_detail, only: :update
  before_action :find_cart_detail, only: :destroy

  def create
    quantity = params[:quantity].to_i
    unless check_quantity(quantity) &&
           check_remain(@product.remain_quantity, quantity)
      render json: {error: I18n.t("cart.add_failed")},
             status: :unprocessable_entity and return
    end

    current_cart_detail = @cart_details.find_by(product_id: @product.id)
    if current_cart_detail
      new_quantity = current_cart_detail.quantity + quantity
      current_cart_detail.update(quantity: new_quantity)
    else
      @cart_details.create(product: @product, quantity:)
    end
    render json: {message: I18n.t("cart.add_success"), cart: @cart}, status: :ok
  end

  def destroy
    @cart_detail.destroy
    render json: {message: I18n.t("cart.delete_success"), cart: @cart},
           status: :ok
  end

  def update
    quantity = params[:quantity].to_i
    unless check_quantity_update(quantity) &&
           check_remain(@current_cart_detail.remain_quantity, quantity)
      render json: {error: I18n.t("cart.update_failed")},
             status: :unprocessable_entity and return
    end

    if check_quantity(quantity)
      @current_cart_detail.update(quantity:)
    else
      @current_cart_detail.destroy
    end
    render json: {message: I18n.t("cart.update_success"), cart: @cart},
           status: :ok
  end

  def show; end

  def check_remain_and_redirect
    if check_remain_availability
      render json: {redirect_to: new_bill_path}, status: :ok and return
    end

    render json: {error: I18n.t("cart.quantity_greater_than_remain")},
           status: :unprocessable_entity
  end

  private

  def find_product_cart
    @product = Product.find_by(id: params[:product_id])
    return if @product

    render json: {error: I18n.t("product.is_nil")},
           status: :not_found
  end

  def find_current_cart_detail
    @current_cart_detail = @cart_details
                           .find_by(product_id: params[:product_id])
    return if @current_cart_detail

    render json: {error: I18n.t("cart_detail.is_nil")},
           status: :not_found
  end

  def find_cart_detail
    @cart_detail = @cart_details.find_by(id: params[:cart_detail_id])
    return if @cart_detail

    render json: {error: I18n.t("cart_detail.is_nil")},
           status: :not_found
  end

  def check_quantity quantity
    quantity > Settings.digit_0
  end

  def check_quantity_update quantity
    quantity >= Settings.digit_0
  end

  def check_remain_availability
    @cart_details.none? do |cart_detail|
      cart_detail.quantity > cart_detail.remain_quantity
    end
  end

  def check_remain remain, quantity
    quantity <= remain
  end

  def load_current_user
    if @current_user
      @cart = @current_user.cart
      @cart_details = @cart.cart_details
      return
    end
    render json: {error: t("flash.not_found", model: "user")},
           status: :not_found
  end
end
