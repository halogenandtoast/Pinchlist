class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :list_proxies
  has_many :lists, :through => :list_proxies, :readonly => false

  def proxy_for(list_or_id)
    list_id = list_or_id.is_a?(List) ? list_or_id.id : list_or_id
    list_proxies.find_by_list_id(list_id)
  end

  def tasks
    Task.where(:list_id => lists.map(&:id))
  end

  def invite_without_email!
    if new_record? || invited?  
      generate_invitation_token if self.invitation_token.nil?
      self.invitation_sent_at = Time.now.utc
      save(:validate => false)
    end
  end

  def self.invite_without_email!
  end
end
