class SessionsController < ApplicationController
  include SessionsHelper

  before_action :find_user_by_email, only: :create
  def new; end

  def create
    if @user&.authenticate params.dig(:session, :password)
      if @user.activated
        log_in @user
        if params.dig(:session,
                      :remember_me) == "1"
          remember(@user)
        else
          forget(@user)
        end
        redirect_back_or @user
      else
        flash[:warning] = t "sessions.create.not_activated"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "sessions.create.invalid"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy; end

  def find_user_by_email
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
  end
end
