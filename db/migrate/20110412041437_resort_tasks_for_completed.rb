class ResortTasksForCompleted < ActiveRecord::Migration
  def self.up
    List.all.each do |list|
      tasks = list.tasks.where(:completed_at => nil).order("tasks.position ASC").to_a
      completed_tasks = list.tasks.where("completed_at IS NOT NULL").order("tasks.position ASC").to_a
      tasks += completed_tasks
      tasks.each_with_index do |task, index|
        task.update_attributes(:position => index)
      end

    end
  end

  def self.down
  end
end
