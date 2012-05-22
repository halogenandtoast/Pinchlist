require 'securerandom'
class ListProxy < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  belongs_to :list
  has_many :tasks, through: :list
  before_create :set_color
  before_create :set_public_token
  after_destroy :notify_list
  acts_as_list scope: :user
  validates_associated :list


  def self.current_tasks
   where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", 7.days.ago.to_date])
  end

  def self.by_task_status
   order("list_proxies.position ASC, tasks.completed ASC, tasks.position ASC")
  end

  delegate :shared?, to: :list

  def shared_users
    list.users.where(["users.id != ?", user_id])
  end

  def self.by_position
    order("position ASC")
  end

  def new_position=(position)
    self.insert_at(position)
  end

  def title
    list.title
  end

  def owned_by?(user)
    owner == user
  end

  def owner
    self.list.user
  end

  def generate_public_token
    set_public_token
    save
  end

  private

  def set_public_token
    begin
      hex = SecureRandom.hex(8)
      sha = Digest::SHA1.hexdigest(Time.now.to_s)
      self.public_token = "#{hex}-#{sha}"
    end while ListProxy.exists?(public_token: self.public_token)
  end

  def set_color
    self.color ||= "%06x" % (rand * 0xffffff)
  end

  def notify_list
    self.list.check_for_proxies
  end
end
