class AddAttachmentImageToKitePosts < ActiveRecord::Migration
  def self.up
    change_table :kite_posts do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :kite_posts, :image
  end
end
