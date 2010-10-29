class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, :dependent => :destroy
  scope :by_task_status, order("lists.position ASC, tasks.completed ASC, tasks.created_at ASC")
  scope :current_tasks, lambda { where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", 7.days.ago.to_date]) }
  before_create :set_position
  before_update :update_positions

  protected
  def set_position
    write_attribute(:position, self.user.lists.count + 1)
  end

  def update_positions
    if position_changed?
      if position_was < self.position
        List.update_all("position = position - 1", "position > #{position_was} && position <= #{self.position}")
      else
        List.update_all("position = position + 1", "position < #{position_was} && position >= #{self.position}")
      end
    end
  end
end
