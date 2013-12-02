class AddTagToKitePost < ActiveRecord::Migration
  def change
    add_column :kite_posts, :tag, :text
  end
end
