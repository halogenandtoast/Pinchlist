class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, :dependent => :destroy
  has_many :proxies, :class_name => "ListProxy"

  after_create :create_proxy

  scope :by_task_status, order("lists.position ASC, tasks.completed ASC, tasks.position ASC")
  scope :current_tasks, lambda { where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", 7.days.ago.to_date]) }

  def title=(title)
    write_attribute(:title, title.blank? ? "List #{self.id}" : title)
  end

  def check_for_proxies
    destroy if proxies.empty?
  end

  private

  def create_proxy
    proxies.create(:user => user)
  end
end
