class AddDueDateToTasks < ActiveRecord::Migration[4.2]
  def self.up
    add_column :tasks, :due_date, :date
  end

  def self.down
    remove_column :tasks, :due_date
  end
end
