class AddCategoryAndTagToKite < ActiveRecord::Migration
  def change
    add_column :kites, :category, :string
    add_column :kites, :tag, :text
  end
end
