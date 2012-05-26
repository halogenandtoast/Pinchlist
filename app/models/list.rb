class List < ActiveRecord::Base
  SUBSCRIBED_LIMIT = 3

  belongs_to :user
  has_many :tasks, :dependent => :destroy
  has_many :proxies, :class_name => "ListProxy"
  has_many :users, :class_name => "User", :source => :user, :through => :proxies

  after_create :create_proxy

  validate :within_subscription, on: :create
  validates :title, presence: true

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
      errors.add(:base, "Upgrade to create more lists.")
    end
  end
end
