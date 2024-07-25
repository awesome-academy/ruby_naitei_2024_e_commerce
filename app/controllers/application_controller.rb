class ApplicationController < ActionController::Base
  before_action :set_locale
  include Pagy::Backend
  include ProductsHelper
  include CategoriesHelper
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
