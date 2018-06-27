class AddPositionToTasks < ActiveRecord::Migration[4.2]
  def self.up
    add_column :tasks, :position, :integer, :default => 1
    Task.update_all("position = 0")
    Task.all.each_with_index { |task, index| task.update_attributes(:position => index + 1) }
  end

  def self.down
    remove_column :tasks, :position
  end
end
