module ApplicationHelper
  include Pagy::Frontend
  include Turbo::FramesHelper
  include Turbo::StreamsHelper

  def full_title page_title
    base_title = t "base_title"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def en price
    t("cart_detail.price",
      price: (price * Settings.dollar_convert).round(Settings.digit_2))
  end

  def vi price
    t("cart_detail.price", price: format_currency(price))
  end

  def format_currency amount
    number_to_currency(amount, unit: Settings.money_unit_d,
                               format: Settings.currency_format)
  end

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = "success" if type == "notice"
      type = "error"   if type == "alert"
      next unless message

      escaped_message = j(message)
      flash_messages << <<~HTML
        <script>
          document.addEventListener("DOMContentLoaded", function() {
            toastr.#{type}("#{escaped_message}");
          });
        </script>
      HTML
    end
    flash_messages.join("\n")
  end

  def get_cart_detail_length?
    @cart_details = current_user.cart.cart_details if logged_in?
    @cart_details.length
  end
end
