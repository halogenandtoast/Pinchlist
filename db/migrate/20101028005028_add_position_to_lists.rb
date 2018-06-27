class AddPositionToLists < ActiveRecord::Migration[4.2]
  def self.up
    add_column :lists, :position, :integer
  end

  def self.down
    remove_column :lists, :position
  end
end
