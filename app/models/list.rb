class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks
  scope :by_task_status, order("lists.created_at ASC, tasks.completed ASC, tasks.created_at ASC")
end
