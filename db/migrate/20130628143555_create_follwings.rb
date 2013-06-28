class CreateFollwings < ActiveRecord::Migration
  def change
    create_table :follwings do |t|
      t.integer :kite_id
      t.integer :user_id

      t.timestamps
    end
  end
end
