class AddDetailsToKite < ActiveRecord::Migration
  def change
    add_column :kites, :Details, :text
  end
end
