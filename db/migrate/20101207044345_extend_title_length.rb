class ExtendTitleLength < ActiveRecord::Migration
  def self.up
    change_column :tasks, :title, :text
  end

  def self.down
    change_column :tasks, :title, :string
  end
end
