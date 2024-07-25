class CreateCartDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_details do |t|
      t.integer :cart_id
      t.integer :product_id
      t.integer :quantity
      t.timestamps
    end
    add_index :cart_details, :cart_id
    add_index :cart_details, :product_id
    add_index :cart_details, [:cart_id, :product_id], unique: true
  end
end
