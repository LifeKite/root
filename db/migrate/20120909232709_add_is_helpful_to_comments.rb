class AddIsHelpfulToComments < ActiveRecord::Migration
  def change
    add_column :comments, :isHelpful, :Boolean

  end
end
