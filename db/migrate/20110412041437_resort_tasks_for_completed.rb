class ResortTasksForCompleted < ActiveRecord::Migration[4.2]
  def self.up
    List.all.each do |list|
      tasks = list.tasks.where(:completed => false).order("tasks.position ASC").to_a
      completed_tasks = list.tasks.where(:completed => true).order("tasks.position ASC").to_a
      tasks += completed_tasks
      tasks.each_with_index do |task, index|
        task.update_attributes(:position => index)
      end

    end
  end

  def self.down
  end
end
