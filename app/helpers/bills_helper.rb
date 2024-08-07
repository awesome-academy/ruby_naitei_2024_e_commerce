module BillsHelper
  def bill_attribute_status status
    I18n.t("order_history.status.#{status}")
  end
end
