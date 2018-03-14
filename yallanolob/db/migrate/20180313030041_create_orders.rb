class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :resturant
      t.string :menu
      t.string :typ
      t.string :statu
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
