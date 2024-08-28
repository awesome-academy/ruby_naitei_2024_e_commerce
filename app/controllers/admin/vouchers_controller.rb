class Admin::VouchersController < AdminController
  def index
    @q = Voucher.ransack(search_params)
    @pagy, @vouchers = pagy(@q.result(distinct: true).recent,
                            items: Settings.page_size)
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

  def search_params
    q_params = params[:q] || {}
    q_params = sanitize_quantity_params q_params, :remain_quantity_gteq,
                                        :remain_quantity_lteq
    q_params = sanitize_quantity_params q_params, :condition_gteq,
                                        :condition_lteq
    parse_date_params q_params, :created_at_gteq, :created_at_lteq
  end

  def sanitize_quantity_params(q_params, *keys)
    keys.each do |key|
      q_params[key] = sanitize q_params[key]
    end
    q_params
  end

  def parse_date_params(q_params, *keys)
    keys.each do |key|
      q_params[key] = parse_date q_params[key]
    end
    q_params
  end

  def parse_date date_string
    Date.parse date_string
  rescue StandardError
    nil
  end

  def sanitize number
    number.to_f >= 0 ? number : nil
  end
end
