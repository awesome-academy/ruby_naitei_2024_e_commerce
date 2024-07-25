class CreateBillDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :bill_details do |t|
      t.integer :bill_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :total, precision: 10, default: 0
      t.timestamps
    end
    add_index :bill_details, :bill_id
    add_index :bill_details, :product_id
    add_index :bill_details, [:bill_id, :product_id], unique: true
  end
end
