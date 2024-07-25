class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :product_id
      t.string :content
      t.integer :parent_comment_id
      t.integer :star
      t.timestamps
    end
  end
end
