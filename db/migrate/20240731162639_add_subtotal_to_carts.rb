class AddSubtotalToCarts < ActiveRecord::Migration[7.0]
  def change
    add_column :carts, :subtotal, :decimal
  end
end
