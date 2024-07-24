class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.integer :remain_quantity
      t.string :description
      t.timestamps
    end
  end
end
