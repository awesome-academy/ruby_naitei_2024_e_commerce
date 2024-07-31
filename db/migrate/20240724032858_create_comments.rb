class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.integer :bill_detail_id
      t.integer :user_id
      t.integer :product_id
      t.string :content
      t.integer :parent_comment_id
      t.integer :star
      t.timestamps
    end
    add_index :comments, :bill_detail_id
    add_index :comments, :product_id
    add_index :comments, :user_id
    add_index :comments, [:bill_detail_id, :product_id, :user_id], unique: true
  end
end
