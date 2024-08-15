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
end
