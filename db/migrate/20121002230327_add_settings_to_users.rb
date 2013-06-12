class AddSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notifyOnKiteComment, :Boolean
    add_column :users, :notifyOnKitePromote, :Boolean
    add_column :users, :sendEmailNotifications, :Boolean

  end
end
