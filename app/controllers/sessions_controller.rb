class SessionsController < ApplicationController
  include SessionsHelper

  before_action :find_user_by_email, only: :create
  def new; end

  def create
    if @user&.authenticate params.dig(:session, :password)
      if @user.activated
        handle_successful_login @user
      else
        handle_failed_activated
      end
    else
      handle_failed_login
    end
  end

  def destroy; end

  def find_user_by_email
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def handle_successful_login user
    log_in user
    if params.dig(:session,
                  :remember_me) == "1"
      remember(user)
    else
      forget(user)
    end
    redirect_back_or root_path
  end

  def handle_failed_activated
    flash[:warning] = t "sessions.create.not_activated"
    redirect_to root_url
  end

  def handle_failed_login
    flash.now[:danger] = t "sessions.create.invalid"
    render :new, status: :unprocessable_entity
  end
end
