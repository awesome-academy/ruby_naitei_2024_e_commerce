class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

    event = parse_event(payload, sig_header)
    return if event.nil?

    handle_event(event)

    render json: {message: "success"}
  end

  private

  def parse_event payload, sig_header
    Stripe::Webhook.construct_event(payload, sig_header,
                                    Figaro.env.webhooks_key)
  rescue JSON::ParserError
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
      event_successful(metadata, session.amount_total)
    end
  end

  def event_successful metadata, amount_total
    @bill = Bill.find_by(id: metadata.bill_id)
    @bill&.update(status: :wait_for_prepare, total: amount_total)
    cart_details_json = metadata.cart_details
    cart_details = JSON.parse(cart_details_json, symbolize_names: true)
    cart_details.each do |detail|
      product = Product.find_by(id: detail[:product_id])
      next unless product

      product.increment!(:sales_count, detail[:quantity])
    end
    @cart = Cart.find_by(user_id: metadata.user_id)
    @cart.cart_details.destroy_all
  end
end
