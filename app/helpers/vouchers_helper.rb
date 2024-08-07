module VouchersHelper
  def voucher_select_options total
    valid_vouchers = Voucher.active.select do |voucher|
      total >= voucher.condition
    end
    {
      collection: valid_vouchers.map{|voucher| [voucher.name, voucher.id]},
      include_blank: "None"
    }
  end
end
