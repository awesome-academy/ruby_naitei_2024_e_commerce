class AddDeletedAtToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :deleted_at, :timestamp
  end
end
