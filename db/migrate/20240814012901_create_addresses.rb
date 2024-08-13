class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :country
      t.string :state
      t.string :city
      t.text :details
      t.integer :bill_id
      t.timestamps
    end
  end
end
