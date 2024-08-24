class Api::V1::BillsController < ApplicationController
  before_action :authenticate_request_api
  before_action :load_current_user, except: :show
  before_action :find_bill, only: :show
  protect_from_forgery with: :null_session
  include BillsHelper

  def index
    @pagy, @bills = pagy(@current_user.bills.newest, items: Settings.page_size)
    render json: {bills: @bills}, status: :ok
  end

  def show
    if @bill.user == @current_user
      render json: {bill: @bill, bill_details: @bill.bill_details},
             status: :ok and return
    end

    render json: {error: t("flash.dont_have_permission")}, status: :forbidden
  end

  def create
    @bill = @current_user.bills.build bill_params
    if @bill.save
      create_stripe_session @cart_details
      transfer_data
      @user.send_bill_info @bill
      @bill_details = @bill.bill_details.includes(:product)
      render json: {
        session_url: @session.url,
        bill: @bill.as_json(
          include: {
            address: {only: Address::PERMITTED_ATTRIBUTES},
            bill_details: {
              include: {
                product: {only: [:name, :price]}
              }
            }
          }
        )
      }, status: :created
    else
      render json: {errors: @bill.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def repayment
    @bill = Bill.find_by(id: params[:bill_id])

    if @bill.user == @current_user
      create_stripe_session @bill.bill_details
      render json: {session_url: @session.url}, status: :ok
    elsif @bill.nil?
      render json: {error: t("flash.not_found", model: t("order.id"))},
             status: :not_found
    else
      render json: {error: t("flash.dont_have_permission")}, status: :forbidden
    end
  end

  private

  def find_bill
    @bill = Bill.includes(:bill_details).find_by(id: params[:id])
    return if @bill

    render json: {error: t("flash.not_found", model: t("order.id"))},
           status: :not_found
  end

  def create_stripe_session line_items
    @line_items = load_lines_item(line_items)
    @metadata = build_metadata(line_items)
    @session = Stripe::Checkout::Session.create(
      payment_method_types: %w(card),
      line_items: @line_items,
      metadata: @metadata,
      payment_method_options: {card: {request_three_d_secure: "any"}},
      mode: "payment",
      success_url: bills_url,
      cancel_url: bills_url
    )
  end

  def build_metadata line_item
    {
      bill_id: @bill.id,
      user_id: @bill.user_id,
      cart_details: line_item.map do |detail|
                      {
                        product_id: detail.product_id,
                        quantity: detail.quantity,
                        total: detail.total
                      }
                    end.to_json
    }
  end

  def load_lines_item cart_details
    amount = Settings.dollar_convert * Settings.digit_100
    cart_details.map do |detail|
      {
        quantity: detail.quantity,
        price_data: {
          currency: Settings.money_unit,
          unit_amount: (detail.product.price * amount).to_i,
          product_data: {
            name: detail.product.name
          }
        }
      }
    end
  end

  def transfer_data
    @cart_details.each do |detail|
      bill_detail = BillDetail.new(
        bill_id: @bill.id,
        product_id: detail.product_id,
        quantity: detail.quantity,
        total: detail.total
      )
      bill_detail.save
    end
  end

  def bill_params
    params.require(:bill).permit(
      Bill::PERMITTED_ATTRIBUTES,
      address_attributes: Address::PERMITTED_ATTRIBUTES
    )
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
