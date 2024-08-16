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
end
