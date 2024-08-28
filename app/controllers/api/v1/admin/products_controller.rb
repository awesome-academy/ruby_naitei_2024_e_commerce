class Api::V1::Admin::ProductsController < ApplicationController
  include Pagy::Backend

  before_action :find_product, only: %i(show update destroy)

  def index
    @q = Product.ransack search_params
    @pagy, @products = pagy(@q.result(distinct: true).newest,
                            items: Settings.page_size)

    serialized_products = ActiveModelSerializers::SerializableResource.new(
      @products, each_serializer: ProductSerializer
    )

    render json: {
      status: true,
      data: serialized_products.as_json[:data]
    }
  end

  def show
    serialized_product = ActiveModelSerializers::SerializableResource.new(
      @product, serializer: ProductSerializer
    )

    render json: {
      status: true,
      data: serialized_product.as_json[:data]
    }
  end

  def create
    @product = Product.new(product_params)
    @product.image.attach(params.dig(:product, :image))

    if @product.save
      serialized_product = ActiveModelSerializers::SerializableResource.new(
        @product, serializer: ProductSerializer
      )

      render json: {
        status: true,
        data: serialized_product.as_json[:data]
      }, status: :created
    else
      render json: {errors: @product.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      serialized_product = ActiveModelSerializers::SerializableResource.new(
        @product, serializer: ProductSerializer
      )

      render json: {
        status: true,
        data: serialized_product.as_json[:data]
      }
    else
      render json: {errors: @product.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      head :no_content
    else
      render json: {errors: @product.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  private

  def find_product
    @product = Product.find_by(id: params[:id])
    return if @product

    render json: {errors: ["Product not found"]},
           status: :not_found
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
