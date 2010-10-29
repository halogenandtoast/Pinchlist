class AddPositionToLists < ActiveRecord::Migration
  def self.up
    add_column :lists, :position, :integer
  end

  def self.down
    remove_column :lists, :position
  end
end
