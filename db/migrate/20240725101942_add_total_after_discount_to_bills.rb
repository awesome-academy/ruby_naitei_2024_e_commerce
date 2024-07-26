class AddTotalAfterDiscountToBills < ActiveRecord::Migration[7.0]
  def change
    add_column :bills, :total_after_discount, :decimal
  end
end
