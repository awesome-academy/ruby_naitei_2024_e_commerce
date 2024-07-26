class UsersController < ApplicationController
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

  private
  def user_params
    params.require(:user).permit(User::PERMITTED_ATTRIBUTES)
  end
end
