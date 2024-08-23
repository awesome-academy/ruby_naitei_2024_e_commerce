class Api::V1::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_action :authenticate_request_api, only: :destroy

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      token = generate_jwt(user)
      render json: {token:}, status: :ok
    else
      render json: {error: t("flash.invalid_email_or_password")},
             status: :unauthorized
    end
  end

  def destroy
    render json: {message: t("flash.log_out_successfully")}, status: :ok
  end

  private

  def generate_jwt user
    payload = {user_id: user.id, exp: Settings.digit_24.hours.from_now.to_i}
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
