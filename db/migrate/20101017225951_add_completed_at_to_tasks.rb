class AddCompletedAtToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :completed_at, :date
  end

  def self.down
    remove_column :tasks, :completed_at
  end
end
