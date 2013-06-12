class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.string :email
      t.integer :user_id
      t.integer :group_id
      t.date :initiated
      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
end
