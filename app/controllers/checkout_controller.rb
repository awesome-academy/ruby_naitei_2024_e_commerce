class CheckoutController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_current_user_cart
  def create
    @bill = Bill.new bill_params
    @bill.save

    @line_items = load_lines_item(@cart_details)
    @metadata = {
      bill_id: @bill.id,
      user_id: @bill.user_id,
      cart_details: @cart_details.map do |detail|
                      {
                        product_id: detail.product_id,
                        quantity: detail.quantity,
                        total: detail.total
                      }
                    end.to_json
    }
    transfer_data
    current_user.send_bill_info @bill
    @session = Stripe::Checkout::Session.create({
      payment_method_types: %w(card),  # rubocop:disable Layout/FirstHashElementIndentation
      line_items: @line_items,
      metadata: @metadata,
      payment_method_options: {card: {request_three_d_secure: "any"}},
      mode: "payment",
      success_url: root_url,
      cancel_url: root_url
                                                })
    respond_to(&:html)
  end

  private

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
