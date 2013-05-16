class AddPrivacyToSharedPurposes < ActiveRecord::Migration
  def change
    add_column :sharedpurposes, :isPrivate, :Boolean

  end
end
