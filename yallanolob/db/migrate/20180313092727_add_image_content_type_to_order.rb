class AddImageContentTypeToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :menu_content_type, :string
    add_column :orders, :menu_file_name, :string
    add_column :orders, :menu_file_size, :integer
    add_column :orders, :menu_updated_at, :datetime
  end
end
