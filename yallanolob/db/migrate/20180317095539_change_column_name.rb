class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :notifications, :type, :typ
  end
end
