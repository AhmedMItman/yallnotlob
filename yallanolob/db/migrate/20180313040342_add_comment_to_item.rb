class AddCommentToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :comment, :text
  end
end
