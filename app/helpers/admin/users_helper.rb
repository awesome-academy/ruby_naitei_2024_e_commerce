module Admin::UsersHelper
  def boolean_to_human value
    value ? t("admin.view.users.yes") : t("admin.view.users.no")
  end
end
