module SessionsHelper
  def logged_in?
    current_user
  end

  def current_user? user
    user == current_user
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def load_current_user_cart
    @cart = current_user.cart
    @cart_details = @cart.cart_details
  end

  def authenticate_request_api
    token = request.headers["Authorization"]&.split(" ")&.last
    if token
      begin
        decoded_token =
          JWT.decode(token, Rails.application.secrets.secret_key_base).first
        @current_user = User.find(decoded_token["user_id"])
      rescue JWT::DecodeError, JWT::ExpiredSignature,
                ActiveRecord::RecordNotFound
        render json: {error: t("flash.invalid_or_expired_token")},
               status: :unauthorized
      end
    else
      render json: {error: t("flash.missing_token")}, status: :unauthorized
    end
  end

  def authenticate_request_api_admin
    authenticate_request_api
    return if @current_user.admin

    render json: {error: t("flash.you_are_not_admin")}, status: :forbidden
  end
end
