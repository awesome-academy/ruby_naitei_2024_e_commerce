class Api::V1::ProductsController < ApplicationController
  include Pagy::Backend

  def index
    @q = Product.ransack search_params
    @pagy, @products = pagy(@q.result(distinct: true).newest,
                            items: Settings.page_size)

    serialized_products = ActiveModelSerializers::SerializableResource.new(
      @products, each_serializer: ProductSerializer
    ).as_json

    render json: {
      status: true,
      data: serialized_products[:data]
    }
  end

  def show
    @product = Product.find(params[:id])
    serialized_product = ActiveModelSerializers::SerializableResource.new(
      @product, serializer: ProductSerializer
    ).as_json

    render json: {
      status: true,
      data: serialized_product[:data]
    }
  end

  private

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
