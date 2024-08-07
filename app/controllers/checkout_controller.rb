class CheckoutController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_current_user_cart
  def create
    @bill = Bill.new bill_params
    if @bill.save
      create_stripe_session @cart_details
      transfer_data
      current_user.send_bill_info @bill
    else
      flash[:danger] = t "flash.syntax_error_phone"
      redirect_to new_bill_path
    end
  end

  def repayment
    @bill = Bill.find_by(id: params[:bill_id])
    if @bill
      create_stripe_session @bill.bill_details
    else
      flash[:danger] = t "not_found", model: t("order.id")
      redirect_to bills_url
    end
  end

  private

  def create_stripe_session line_items
    @line_items = load_lines_item(line_items)
    @metadata = build_metadata(line_items)

    @session = Stripe::Checkout::Session.create({
      payment_method_types: %w(card), # rubocop:disable Layout/FirstHashElementIndentation
      line_items: @line_items,
      metadata: @metadata,
      payment_method_options: {card: {request_three_d_secure: "any"}},
      mode: "payment",
      success_url: bills_url,
      cancel_url: bills_url
                                                })
    redirect_to @session.url, allow_other_host: true
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
    @line_items = cart_details.map do |detail|
      {
        quantity: detail.quantity,
        price_data: {
          currency: Settings.money_unit,
          unit_amount:
            (detail.product.price * Settings.dollar_convert * 100).to_i,
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
    params.require(:bill).permit(Bill::PERMITTED_ATTRIBUTES)
  end
end
