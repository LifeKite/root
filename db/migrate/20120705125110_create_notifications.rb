class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.date :notificationDate
      t.integer :user_id
      t.string :message
      t.string :state
      t.timestamps
    end
  end
end
