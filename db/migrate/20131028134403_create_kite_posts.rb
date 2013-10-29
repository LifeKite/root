class CreateKitePosts < ActiveRecord::Migration
  def change
    create_table :kite_posts do |t|
      t.text :text

      t.timestamps
    end
  end
end
