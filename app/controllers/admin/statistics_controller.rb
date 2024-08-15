class Admin::StatisticsController < AdminController
  before_action :validate_filter
  before_action :range_filter

  def index
    @users_signup = User.users_signup(@datefrom, @dateto)
    @hot_products = hot_products
    @status_bills = Bill.status_bills(@datefrom, @dateto)
    @incomes = Bill.incomes(@datefrom, @dateto)
  end

  private

  def validate_filter
    if params[:datefrom] && params[:dateto]
      @parsed_date_from = Date.parse(params[:datefrom])
      @parsed_date_to = Date.parse(params[:dateto])
      handle_date_error if @parsed_date_from >= @parsed_date_to
    end
  rescue ArgumentError
    handle_invalid_date_format_error
  end

  def handle_date_error
    flash[:danger] = t("admin.statistic.date_error")
    redirect_to admin_statistics_path
  end

  def handle_invalid_date_format_error
    flash[:danger] = t("admin.statistic.format_error")
    redirect_to admin_statistics_path
  end

  def range_filter
    @datefrom = parse_date(params[:datefrom])&.beginning_of_day ||
                Time.zone.now.beginning_of_month.midnight
    @dateto = parse_date(params[:dateto])&.end_of_day ||
              Time.zone.now
  end

  def parse_date date_param
    Time.zone.parse(date_param) if date_param.present?
  end

  def hot_products
    Product.order(sales_count: :desc)
           .limit(Settings.page_size)
           .pluck(:name, :sales_count).to_h
  end
end
