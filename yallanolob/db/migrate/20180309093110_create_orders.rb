class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.belongs_to :user, index: true
      t.string :resturant
      t.string :menu
      t.string :type
      t.string :status

      t.timestamps
    end
  end
end
