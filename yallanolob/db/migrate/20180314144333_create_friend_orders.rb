class CreateFriendOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :friend_orders do |t|
      t.integer :order_id
      t.integer :friend_id
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
