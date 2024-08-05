class AddUnitPriceToCartDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_details, :unit_price, :decimal
  end
end
