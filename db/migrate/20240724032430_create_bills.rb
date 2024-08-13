class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.integer :user_id
      t.string :phone_number
      t.integer :voucher_id
      t.integer :status
      t.string :note_content
      t.decimal :total
      t.timestamp :expired_at
      t.timestamps
    end
  end
end
