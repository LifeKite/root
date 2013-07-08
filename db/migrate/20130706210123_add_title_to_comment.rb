class AddTitleToComment < ActiveRecord::Migration
  def change
    add_column :comments, :Title, :text
  end
end
