class Admin::CategoriesController < AdminController
  layout "admin"
  include ApplicationHelper
  before_action :load_category, only: %i(edit update destroy)

  def index
    @search = Category.ransack params[:q]
    if invalid_date_range?
      flash.now[:danger] = t "flash.end_date_not_earlier"
      @pagy, @categories = pagy(Category.none, items: Settings.digit_0)
    else
      @pagy, @categories = pagy(@search.result, items: Settings.digit_5)
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    @category.image.attach params.dig(:category, :image)
    if @category.save
      flash.now[:success] = t "flash.create_successfully"
      render :new, status: :see_other
    else
      flash.now[:danger] = t "flash.create_unsuccessfully"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category.image.attach params.dig(:category, :image)
    if @category.update category_params
      flash[:success] = t "flash.update_successfully"
      redirect_to admin_categories_path, status: :see_other
    else
      flash.now[:danger] = t "flash.update_unsuccessfully"
      render :edit, status: :unprocessable_entity
    end
  end

  def edit; end

  def destroy
    if @category.destroy
      flash.now[:success] = t "flash.delete_successfully"
    else
      flash.now[:danger] = t "flash.delete_unsuccessfull"
    end
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit(:name, :parent_category_id)
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:danger] = t "flash.not_found", model: t("category.title")
    redirect_to admin_categories_path
  end

  def parse_date date_str
    date_str.blank? ? nil : Date.parse(date_str)
  end

  def invalid_date_range?
    start_date = parse_date params.dig(:q, :created_at_gteq)
    end_date = parse_date params.dig(:q, :created_at_lteq)
    start_date && end_date && start_date > end_date
  end
end
