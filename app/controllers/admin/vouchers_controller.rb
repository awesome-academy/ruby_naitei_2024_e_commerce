class Admin::VouchersController < AdminController
  def index
    @pagy, @vouchers = pagy(Voucher.recent, items: Settings.page_size)
  end
end
