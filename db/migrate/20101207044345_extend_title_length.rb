class ExtendTitleLength < ActiveRecord::Migration[4.2]
  def self.up
    change_column :tasks, :title, :text
  end

  def self.down
    change_column :tasks, :title, :string
  end
end
