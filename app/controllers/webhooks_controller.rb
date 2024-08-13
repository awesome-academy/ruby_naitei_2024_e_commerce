class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

    event = parse_event payload, sig_header
    return if event.nil?

    handle_event event

    render json: {message: "success"}
  end

  private

  def parse_event payload, sig_header
    Stripe::Webhook.construct_event(payload, sig_header,
                                    Figaro.env.webhooks_local_key)
  rescue JSON::ParserError => e
    Rails.logger.error "Invalid JSON payload: #{e.message}"
    status 400
    nil
  rescue Stripe::SignatureVerificationError
    Rails.logger.debug "Signature error"
    nil
  end

  def handle_event event
    case event.type
    when "checkout.session.completed"
      session = event.data.object
      metadata = session.metadata
      event_successful metadata
    end
  end

  def event_successful metadata
    @bill = Bill.find_by id: metadata.bill_id
    @cart = Cart.find_by user_id: metadata.user_id
    cart_details_json = metadata.cart_details
    cart_details = JSON.parse cart_details_json, symbolize_names: true

    begin
      ActiveRecord::Base.transaction do
        update_bill_and_cart
        process_cart_details cart_details
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::Rollback => e
      handle_transaction_failure e
    end
  end

  def update_bill_and_cart
    @bill.update! status: :wait_for_prepare, expired_at: nil
    @cart.update! total: Settings.digit_0
    @cart.cart_details.try :destroy_all
  end

  def process_cart_details cart_details
    cart_details.each do |detail|
      product = Product.find_by id: detail[:product_id]
      next unless product

      update_product_stock_and_sales product, detail[:quantity]
    end
  end

  def update_product_stock_and_sales product, quantity
    product.remain_quantity -= quantity
    product.increment! :sales_count, quantity
    product.save!
  end

  def handle_transaction_failure error
    @bill.update status: :cancelled,
                 cancellation_reason: :out_of_stock
    Rails.logger.error "Error processing event: #{error.message}"
  end
end
