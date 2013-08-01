class AddAttachmentKiteimageToKites < ActiveRecord::Migration
  def self.up
    change_table :kites do |t|
      t.attachment :kiteimage
    end
  end

  def self.down
    drop_attached_file :kites, :kiteimage
  end
end
