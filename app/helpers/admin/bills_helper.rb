module Admin::BillsHelper
  def discount_to_percentage discount
    return "N/A" if discount.nil?

    percentage = (discount * Settings.digit_100).round
    "#{percentage}%"
  end

  def format_expired_at expired_at
    expired_at.present? ? l(expired_at, format: :long) : "N/A"
  end
end
