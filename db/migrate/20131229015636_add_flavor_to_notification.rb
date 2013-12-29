class AddFlavorToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :flavor, :string
  end
end
