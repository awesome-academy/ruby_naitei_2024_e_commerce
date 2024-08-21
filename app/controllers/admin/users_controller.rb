class Admin::UsersController < AdminController
  def index
    @q = User.ransack(search_params)
    @pagy, @users = pagy(@q.result(distinct: true).all_users,
                         items: Settings.page_size)
  end
end

private

def search_params
  params[:q] || {}
end
