class BillsController < ApplicationController
  before_action :user_signed_in?, :load_current_user_cart
  before_action :find_bill, only: :show
  protect_from_forgery with: :exception
  include BillsHelper

  def index
    @pagy, @bills = pagy(current_user.bills.newest, items: Settings.page_size)
  end

  def show
    @bill_details = @bill.bill_details
  end

  def new
    @bill = Bill.new
  end

  def update_total
    voucher = Voucher.find_by id: params[:voucher_id]
    if voucher
      total_discount = @cart.total - @cart.total * voucher.discount
      discount_voucher = voucher.discount * Settings.digit_100
    else
      total_discount = @cart.total
      discount_voucher = nil
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
                turbo_stream.replace("total-price",
                                     partial: "update_total",
                                     locals: {total: total_discount,
                                              discount: discount_voucher})
      end
    end
  end

  private

  def find_bill
    @bill = Bill.includes(:bill_details).find_by(id: params[:id])
    return if @bill

    flash[:alert] = t "errors.bill.not_found"
    redirect_to root_path and return
  end
end
