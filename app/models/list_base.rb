class ListBase < ActiveRecord::Base
  SUBSCRIBED_LIMIT = 3

  belongs_to :user
  has_many :tasks, :dependent => :destroy
  has_many :lists
  has_many :users, :class_name => "User", :source => :user, :through => :lists
  has_many :shares

  validate :within_subscription, on: :create

  def self.by_task_status
    order("lists.position ASC, tasks.completed ASC, tasks.position ASC")
  end

  def self.current_tasks
    active_date = 7.days.ago.to_date
    where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", active_date])
  end

  def title=(title)
    write_attribute(:title, title.blank? ? "List #{self.id}" : title)
  end

  def check_for_lists
    destroy if lists.empty?
  end

  def shared?
    lists.count > 1
  end

  def shared_users
    users.where(["users.id != ?", user_id])
  end

  private

  def within_subscription
    if !user.subscribed? && user.lists_count >= SUBSCRIBED_LIMIT
      errors.add(:base, "Upgrade to create more lists.")
    end
  end
end
