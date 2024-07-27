class ApplicationController < ActionController::Base
  before_action :set_locale
  include Pagy::Backend
  include ProductsHelper
  include CategoriesHelper
  include SessionsHelper

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "flash.not_admin"
    redirect_to root_path
  end
end
