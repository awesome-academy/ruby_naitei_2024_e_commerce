class AddDeletedAtToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :deleted_at, :timestamp
  end
end
