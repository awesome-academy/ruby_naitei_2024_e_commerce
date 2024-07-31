class ApplicationController < ActionController::Base
  before_action :set_locale
  include Pagy::Backend
  include ApplicationHelper
  include ProductsHelper
  include CategoriesHelper
  include SessionsHelper
  include VouchersHelper

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "please_log_in"
    store_location
    redirect_to login_path
  end
end
