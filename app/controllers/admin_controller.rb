class AdminController < ApplicationController
  include SessionsHelper
  before_action :require_admin

  private

  def require_admin
    return if current_user&.admin?

    redirect_to products_path
    flash[:danger] = t "error.user_not_admin"
  end
end
