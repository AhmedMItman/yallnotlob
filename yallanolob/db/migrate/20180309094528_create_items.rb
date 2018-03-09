class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.belongs_to :user, index: true
      t.belongs_to :order, index: true
      t.integer :quantity
      t.float :price

      t.timestamps
    end
  end
end
