class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, :dependent => :destroy
  before_create :set_color
  scope :by_task_status, order("lists.position ASC, tasks.completed ASC, tasks.position ASC")
  scope :current_tasks, lambda { where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", 7.days.ago.to_date]) }
  acts_as_list :scope => :user

  def new_position=(position)
    self.insert_at(position)
  end

  def title=(title)
    write_attribute(:title, title.blank? ? "List #{self.id}" : title)
  end

  private

  def set_color
    self.color ||= "%06x" % (rand * 0xffffff)
  end
end
