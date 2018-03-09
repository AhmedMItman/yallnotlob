class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.string :message
      t.string :from
      t.string :type
      t.integer :orderId

      t.timestamps
    end
  end
end
