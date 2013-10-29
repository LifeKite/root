class AddKiteIdToKitePost < ActiveRecord::Migration
  def change
    add_column :kite_posts, :kite_id, :integer
  end
end
