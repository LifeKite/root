class AddTagToComment < ActiveRecord::Migration
  def change
    add_column :comments, :tag, :text
  end
end
