class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      handle_successful_authentication
    else
      handle_failed_authentication
    end
  end

  private

  def handle_successful_authentication
    flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "Google")
    sign_in_and_redirect @user, event: :authentication
  end

  def handle_failed_authentication
    session["devise.google_data"] = request.env["omniauth.auth"].except(:extra)
    redirect_to new_user_registration_url,
                alert: @user.errors.full_messages.join("\n")
  end
end
