class Admin::CategoriesController < ApplicationController
  include ApplicationHelper
  before_action :load_category, only: %i(edit update destroy)
  def index
    @pagy, @categories = pagy Category.oldest, limit: Settings.page_size
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash.now[:success] = t "flash.create_successfully"
      render :new, status: :see_other
    else
      flash.now[:danger] = t "flash.create_unsuccessfully"
      render :new, status: :unprocessable_entity
    end
  end

  def update
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
end
