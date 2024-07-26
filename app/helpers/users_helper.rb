module UsersHelper
  def password_fields form
    form.password_field(:password, placeholder: t("sign_up.password"),
                                class: "formdk__taikhoan") +
      form.password_field(:password_confirmation,
                          placeholder: t("sign_up.password_confirmation"),
                          class: "formdk__taikhoan")
  end

  def gender_field form
    form.label(:gender, t("sign_up.gender")) +
      form.select(:gender, User.genders.keys.map do |gender|
        [t("sign_up.genders.#{gender}"), gender]
      end, {}, class: "formdk__gioitinh")
  end
end
