require 'securerandom'

class ListProxy < ActiveRecord::Base
  acts_as_list scope: :user

  belongs_to :user, counter_cache: true
  belongs_to :list
  has_many :tasks, through: :list

  before_create :set_color
  before_create :set_public_token
  before_save :set_slug
  after_destroy :notify_list

  validates_associated :list

  delegate :title, :shared?, to: :list

  def self.current_tasks
    active_date = 7.days.ago.to_date
   where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", active_date])
  end

  def self.by_task_status
   order("list_proxies.position ASC, tasks.completed ASC, tasks.position ASC")
  end

  def shared_users
    list.users.where(["users.id != ?", user_id])
  end

  def self.by_position
    order("position ASC")
  end

  def new_position=(position)
    self.insert_at(position)
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

  def self.public_from_params(params)
    where(public: true, public_token: params[:id], slug: params[:slug]).first!
  end

  def toggle_public
    self.public = !self.public
    save
  end

  private

  def set_public_token
    if self.public_token.nil?
      begin
        self.public_token = SecureRandom.hex(5)
      end while ListProxy.exists?(slug: title.parameterize, public_token: self.public_token)
    end
  end

  def set_color
    self.color ||= "%06x" % (rand * 0xffffff)
  end

  def set_slug
    self.slug = title.parameterize
  end

  def notify_list
    self.list.check_for_proxies
  end
end
