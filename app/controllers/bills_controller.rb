class BillsController < ApplicationController
  before_action :logged_in_user, :load_current_user_cart
  protect_from_forgery with: :exception

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
end
