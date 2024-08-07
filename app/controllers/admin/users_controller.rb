class Admin::UsersController < AdminController
  def index
    @pagy, @users = pagy(User.all_users, items: Settings.page_size)
  end
end
