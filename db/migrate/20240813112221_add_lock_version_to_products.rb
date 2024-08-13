class AddLockVersionToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :lock_version, :integer, default: 0, null: false
  end
end
