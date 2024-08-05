class Admin::BillsController < AdminController
  def index
    @pagy, @bills = pagy(Bill.order(created_at: :desc),
                         items: Settings.page_size)
  end
end
