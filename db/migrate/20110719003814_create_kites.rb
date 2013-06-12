class CreateKites < ActiveRecord::Migration
  def self.up
    create_table :kites do |t|
      t.text :Description
      t.boolean :Completed
      t.date :CreateDate
      t.date :CompleteDate
      t.text :ImageLocation
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :kites
  end
end
