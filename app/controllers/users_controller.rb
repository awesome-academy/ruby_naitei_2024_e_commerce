class UsersController < ApplicationController
  include SessionsHelper
  before_action :logged_in_user, :find_user, :correct_user,
                only: %i(edit update)

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "sign_up.notification_mail"
      redirect_to signup_path
    else
      flash.now[:danger] = t "user_creation_failed"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user&.update user_params
      flash[:success] = t "user_update_successfully"
      redirect_to @user
    else
      flash.now[:danger] = t "user_update_failed"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(User::PERMITTED_ATTRIBUTES)
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path unless @user
  end

  def logged_in_user
    return if logged_in?

    flash[:danger] = t "please_log_in"
    store_location
    redirect_to login_path
  end

  def correct_user
    return if current_user? @user

    flash[:error] = t "error.user_not_correct"
    redirect_to root_path
  end
end
