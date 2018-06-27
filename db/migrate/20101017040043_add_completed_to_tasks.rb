class AddCompletedToTasks < ActiveRecord::Migration[4.2]
  def self.up
    add_column :tasks, :completed, :boolean, :default => false
  end

  def self.down
    remove_column :tasks, :completed
  end
end
