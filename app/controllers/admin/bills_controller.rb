class Admin::BillsController < AdminController
  before_action :find_bill, only: %i(show update_status)
  def index
    @pagy, @bills = pagy(Bill.order(created_at: :desc),
                         items: Settings.page_size)
  end

  def show; end

  def update_status
    if @bill.update bill_params
      flash.now[:success] = t "admin.view.bill_updated_successfully"
      respond_to do |format|
        format.turbo_stream
        format.html{redirect_to @bill}
      end
    else
      flash.now[:danger] = t "admin.view.bill_update_failed"
      render :show, status: :unprocessable_entity
    end
  end

  private

  def find_bill
    @bill = Bill.find_by(id: params[:id])
    return if @bill

    flash[:danger] = t "bills.not_found"
    redirect_to admin_bills_path
  end

  def bill_params
    params.require(:bill).permit(:status)
  end
end
