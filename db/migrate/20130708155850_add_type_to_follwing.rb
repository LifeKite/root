class AddTypeToFollwing < ActiveRecord::Migration
  def change
    add_column :follwings, :Type, :string
  end
end
