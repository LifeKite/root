class CreateSharedpurposekites < ActiveRecord::Migration
  def change
    create_table :sharedpurposekites do |t|
      t.integer :kite_id
      t.integer :sharedpurpose_id
      t.timestamps
    end
  end
  def self.down
    drop_table :sharedpurposekites
  end
end
