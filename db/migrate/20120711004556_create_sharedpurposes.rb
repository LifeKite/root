class CreateSharedpurposes < ActiveRecord::Migration
  def change
    create_table :sharedpurposes do |t|
      t.string :name
      t.integer :founder_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :sharedpurposes
  end
end
