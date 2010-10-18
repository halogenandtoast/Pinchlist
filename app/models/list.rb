class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks
  scope :by_task_status, order("lists.created_at ASC, tasks.completed ASC, tasks.created_at ASC")
  scope :current_tasks, where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", 7.days.ago])
end
