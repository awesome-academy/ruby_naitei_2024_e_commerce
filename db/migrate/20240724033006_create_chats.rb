class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :message
      t.timestamps
    end
    add_index :chats, :sender_id
    add_index :chats, :receiver_id
    add_index :chats, [:sender_id, :receiver_id], unique: true
  end
end
