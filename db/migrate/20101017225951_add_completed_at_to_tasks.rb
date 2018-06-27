class AddCompletedAtToTasks < ActiveRecord::Migration[4.2]
  def self.up
    add_column :tasks, :completed_at, :date
  end

  def self.down
    remove_column :tasks, :completed_at
  end
end
