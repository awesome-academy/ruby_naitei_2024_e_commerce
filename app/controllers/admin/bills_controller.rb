class Admin::BillsController < AdminController
  def index
    @pagy, @bills = pagy(Bill.order(created_at: :desc),
                         items: Settings.page_size)
  end

  def show
    @bill = Bill.find_by(id: params[:id])
    return if @bill

    flash[:danger] = t "bills.not_found"
    redirect_to admin_bills_path
  end
end
