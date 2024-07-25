class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.integer :gender
      t.boolean :admin
      t.timestamps
    end
  end
end
