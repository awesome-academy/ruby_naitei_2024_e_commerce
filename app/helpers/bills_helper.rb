module BillsHelper
  def bill_attribute_status status
    I18n.t("order_history.status.#{status}")
  end

  def bill_cancellation_reason reason
    I18n.t("order_history.cancellation_reason.#{reason}")
  end

  def full_address address
    "#{address.details}, #{address.city}, #{address.state}, #{address.country}"
  end

  def progress_bar_width status
    case status
    when "wait_for_pay"
      "20%"
    when "wait_for_prepare"
      "40%"
    when "wait_for_delivery"
      "60%"
    when "completed"
      "80%"
    when "cancelled"
      "100%"
    else
      "0%"
    end
  end
end
