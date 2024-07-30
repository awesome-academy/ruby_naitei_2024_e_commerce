class Admin::BaseAdminController < ApplicationController
  layout "admin"
  before_action :admin_user
end
