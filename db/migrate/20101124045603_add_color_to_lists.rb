class AddColorToLists < ActiveRecord::Migration
  def self.up
    add_column :lists, :color, :string
    List.all.each do |list|
      list.update_attributes(:color => "%06x" % (rand * 0xffffff))
    end
  end

  def self.down
    remove_column :lists, :color
  end
end
