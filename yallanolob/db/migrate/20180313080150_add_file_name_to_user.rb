class AddFileNameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :image_file_name, :string
  end
end
