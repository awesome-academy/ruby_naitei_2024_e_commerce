module CategoriesHelper
  def category_select_options
    {
      collection: Category.oldest.map{|category| [category.name, category.id]},
      include_blank: "None"
    }
  end

  def category_options
    Category.all_categories.pluck(:name, :id)
  end
end
