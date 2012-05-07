class List < ActiveRecord::Base
  SUBSCRIBED_LIMIT = 3
  belongs_to :user
  has_many :tasks, :dependent => :destroy
  has_many :proxies, :class_name => "ListProxy"
  has_many :users, :class_name => "User", :source => :user, :through => :proxies
  validate :within_subscription, :on => :create

  after_create :create_proxy

  scope :by_task_status, order("lists.position ASC, tasks.completed ASC, tasks.position ASC")
  scope :current_tasks, lambda { where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", 7.days.ago.to_date]) }

  def title=(title)
    write_attribute(:title, title.blank? ? "List #{self.id}" : title)
  end

  def check_for_proxies
    destroy if proxies.empty?
  end

  def shared?
    self.proxies.count > 1
  end

  def shared_users
    users.where(["users.id != ?", user_id])
  end

  private

  def create_proxy
    self.proxies.create(user: user)
  end

  def within_subscription
    if !user.subscribed? && user.list_proxies_count >= SUBSCRIBED_LIMIT
      errors.add(:base, "Please upgrade to have additional lists.")
    end
  end
end
