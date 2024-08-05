class CreateVouchers < ActiveRecord::Migration[7.0]
  def change
    create_table :vouchers do |t|
      t.string :name
      t.decimal :condition
      t.float :discount
      t.timestamp :started_at
      t.timestamp :ended_at
      t.timestamps
    end
  end
end
