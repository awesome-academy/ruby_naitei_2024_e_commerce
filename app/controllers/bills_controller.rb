class BillsController < ApplicationController
  before_action :authenticate_user!, :load_current_user_cart
  before_action :find_bill, only: %i(show cancel)
  protect_from_forgery with: :exception
  include BillsHelper
  def index
    @pagy, @bills = pagy(current_user.bills.newest, items: Settings.page_size)
  end

  def show
    @user_cancellation_reason = Bill::USER_CANCEL_REASONS
    @bill_details = @bill.bill_details
  end

  def new
    @bill = Bill.new
    @bill.build_address
  end

  def create
    @bill = current_user.bills.build bill_params
    if @bill.save
      create_stripe_session @cart_details
      transfer_data
      current_user.send_bill_info @bill
      redirect_to @session.url, allow_other_host: true
    else
      render :new, status: :unprocessable_entity
    end
  end

  def repayment
    @bill = Bill.find_by id: params[:bill_id]
    if @bill
      create_stripe_session @bill.bill_details
      redirect_to @session.url, allow_other_host: true
    else
      flash[:danger] = t "not_found", model: t("order.id")
      redirect_to bills_url
    end
  end

  def update_total
    voucher = Voucher.find_by id: params[:voucher_id]
    if voucher
      @total_discount = @cart.total - @cart.total * voucher.discount
      @discount_voucher = voucher.discount * Settings.digit_100
    else
      @total_discount = @cart.total
      @discount_voucher = nil
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
                turbo_stream.replace("total-price",
                                     partial: "update_total",
                                     locals: {total: @total_discount,
                                              discount: @discount_voucher})
      end
    end
  end

  def states
    @target = params[:target]
    @states = CS.get(params[:country]).invert
    respond_to :turbo_stream
  end

  def cities
    @target = params[:target]
    @cities = CS.cities(params[:state]) || []
    respond_to :turbo_stream
  end

  def cancel
    if @bill.update(bill_cancel_params.merge(status: :cancelled))
      flash[:success] = t "order_history.cancel_success"
    else
      flash[:alert] = t "order_history.cancel_fail"
    end
    redirect_to @bill
  end

  private

  def find_bill
    @bill = Bill.includes(:bill_details).find_by(id: params[:id])
    return if @bill

    flash[:alert] = t "errors.bill.not_found"
    redirect_to root_path and return
  end

  def create_stripe_session line_items
    @line_items = load_lines_item(line_items)
    @metadata = build_metadata(line_items)
    @session = Stripe::Checkout::Session.create(
      {
        payment_method_types: %w(card),
        line_items: @line_items,
        metadata: @metadata,
        payment_method_options: {card: {request_three_d_secure: "any"}},
        mode: "payment",
        success_url: bills_url,
        cancel_url: bills_url
      }
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
    @line_items = cart_details.map do |detail|
      {
        quantity: detail.quantity,
        price_data: {
          currency: Settings.money_unit,
          unit_amount:
            (detail.product.price * amount).to_i,
          product_data: {
            name: detail.product.name
          }
        }
      }
    end
  end

  def transfer_data
    @cart_details.each do |detail|
      bill_detail = BillDetail.new bill_id: @bill.id,
                                   product_id: detail.product_id,
                                   quantity: detail.quantity,
                                   total: detail.total
      next unless bill_detail.save
    end
  end

  def bill_params
    params.require(:bill).permit(
      Bill::PERMITTED_ATTRIBUTES,
      address_attributes: Address::PERMITTED_ATTRIBUTES
    )
  end

  def bill_cancel_params
    params.require(:bill).permit(:cancellation_reason)
  end
end
