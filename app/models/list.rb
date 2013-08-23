require 'securerandom'

class List < ActiveRecord::Base
  SUBSCRIBED_LIMIT = 3

  attr_accessor :new_position
  acts_as_list scope: :user

  belongs_to :user, counter_cache: true
  belongs_to :list_base
  has_many :tasks, through: :list_base, before_add: :set_list_base_id

  before_create :ensure_within_limit
  before_create :set_color
  before_create :set_public_token
  before_validation :set_list_base

  after_destroy :notify_list_base
  before_save :set_slug

  validates_associated :list_base
  validates :title, presence: true
  validates :list_base_id, presence: true

  delegate :shares, :shared?, to: :list_base

  def self.current_tasks
    active_date = 7.days.ago.to_date
   where(["(tasks.completed_at IS NULL OR tasks.completed_at > ?)", active_date])
  end

  def self.by_task_status
   order("lists.position ASC, tasks.completed ASC, tasks.position ASC")
  end

  def shares
    list_base.lists.reject{ |list| list.id == id }.map { |list| { id: list.id, email: list.user.email } }
  end

  def shared_users
    list_base.users.where(["users.id != ?", user_id])
  end

  def share_with(user)
    shared_list = dup
    shared_list.user_id = user.id
    shared_list.save
    shared_list
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
    self.list_base.user
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
      end while List.exists?(slug: title.parameterize, public_token: self.public_token)
    end
  end

  def set_color
    self.color ||= "%06x" % (rand * 0xffffff)
  end

  def set_slug
    self.slug = title.parameterize
  end

  def notify_list_base
    self.list_base.check_for_lists
  end

  def set_list_base
    if list_base_id.nil?
      create_list_base(user: user)
    end
  end

  def set_list_base_id(task)
    task.list_base = list_base
  end

  def ensure_within_limit
    unless user.subscribed?
      if user.lists.count >= SUBSCRIBED_LIMIT
        errors.add(:base, "Upgrade to create more lists.")
      end
    end
  end

end
