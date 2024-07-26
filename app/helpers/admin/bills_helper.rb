module Admin::BillsHelper
  def discount_to_percentage discount
    return "N/A" if discount.nil?

    percentage = (discount * Settings.digit_100).round
    "#{percentage}%"
  end

  def format_expired_at expired_at
    expired_at.present? ? l(expired_at, format: :long) : "N/A"
  end

  def format_currency amount
    number_to_currency(amount, unit: Settings.money_unit_d,
                               format: Settings.currency_format)
  end

  def format_product_total detail
    number_to_currency(
      detail.quantity * detail.product.price,
      unit: Settings.money_unit_d,
      format: Settings.currency_format
    )
  end

  def display_voucher_discount voucher
    voucher ? discount_to_percentage(voucher.discount) : "N/A"
  end
end
