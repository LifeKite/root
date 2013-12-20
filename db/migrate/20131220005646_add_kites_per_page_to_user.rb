class AddKitesPerPageToUser < ActiveRecord::Migration
  def change
    add_column :users, :kitesperpage, :integer
  end
end
