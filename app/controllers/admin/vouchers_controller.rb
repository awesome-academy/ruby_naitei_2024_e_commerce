class Admin::VouchersController < AdminController
  def index
    @pagy, @vouchers = pagy(Voucher.recent, items: Settings.page_size)
  end

  def new
    @voucher = Voucher.new
  end

  def create
    @voucher = Voucher.new voucher_params
    if @voucher.save
      flash[:success] = t "admin.voucher.create.success"
      redirect_to admin_vouchers_path
    else
      flash[:danger] = t "admin.voucher.create.fail"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def voucher_params
    params.require(:voucher).permit(Voucher::PERMITTED_ATTRIBUTES)
  end
end
