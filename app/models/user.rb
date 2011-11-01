class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :list_proxies
  has_many :lists, :through => :list_proxies, :readonly => false
  has_many :owned_lists, :class_name => "List"
  has_many :subscriptions

  def proxy_for(list_or_id)
    list_id = list_or_id.is_a?(List) ? list_or_id.id : list_or_id
    list_proxies.find_by_list_id(list_id)
  end

  def current_subscription
    subscriptions.current.first
  end

  def subscribed?
    current_subscription
  end

  def tasks
    Task.where(:list_id => lists.map(&:id))
  end

  def invitation_to_share(list)
    generate_invitation_token
    self.invitation_sent_at = Time.now
    save(:validate => false)
    InvitationWithShareMailer.invitation_for(self, list)
  end

end
