class AddSharelevelToKites < ActiveRecord::Migration
  def change
    add_column :kites, :sharelevel, :string

  end
end
