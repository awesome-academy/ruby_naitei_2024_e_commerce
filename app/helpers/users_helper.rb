module UsersHelper
  def gender_field form
    form.label(:gender, t("sign_up.gender")) +
      form.select(:gender, User.genders.keys.map do |gender|
        [t("sign_up.genders.#{gender}"), gender]
      end, {}, class: "formdk__gioitinh")
  end

  def find_liked_product current_user, product
    current_user.wishlist_products.find_by(id: product.id)
  end
end
