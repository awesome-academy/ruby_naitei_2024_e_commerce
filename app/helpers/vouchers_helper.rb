module VouchersHelper
  def voucher_select_options
    {
      collection: Voucher.active.map{|voucher| [voucher.name, voucher.id]},
      include_blank: "None"
    }
  end
end
