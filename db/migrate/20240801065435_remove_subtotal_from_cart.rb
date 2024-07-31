class RemoveSubtotalFromCart < ActiveRecord::Migration[7.0]
  def change
    remove_column :carts, :subtotal, :decimal
  end
end
