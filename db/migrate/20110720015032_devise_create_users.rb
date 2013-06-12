class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|

      t.string :username, :null => false
      t.string :firstname
      t.string :lastname
      t.string :email,              :null => false, :default => ""

      t.timestamps
    end

    add_index :users, :email,                :unique => true
   
  end

  def self.down
    drop_table :users
  end
end
