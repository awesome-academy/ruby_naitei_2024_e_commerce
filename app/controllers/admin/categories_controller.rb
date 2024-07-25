class Admin::CategoriesController < ApplicationController
  include ApplicationHelper
  def index
    @pagy, @categories = pagy Category.oldest, limit: Settings.page_size
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash.now[:success] = t("flash.create_successfully")
      render :new, status: :see_other
    else
      flash.now[:danger] = t("flash.create_unsuccessfully")
      render :new, status: :unprocessable_entity
    end
  end

  private
  def category_params
    params.require(:category).permit(:name, :parent_category_id)
  end
end
