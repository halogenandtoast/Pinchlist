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

  def proxy_for(list_or_id)
    list_id = list_or_id.is_a?(List) ? list_or_id.id : list_or_id
    list_proxies.find_by_list_id(list_id)
  end

  def tasks
    Task.where(:list_id => lists.map(&:id))
  end

  def invite_with_share!(list)
    generate_invitation_token
    self.invitation_sent_at = Time.now
    save(:validate => false)
    InvitationWithShareMailer.invitation_for(self, list).deliver
  end

  def self.share_by_email(email, list)
    user = find_or_create_by_email(email)
    if user.new_record?
      user.invite_with_share!(list)
    else
      MemberMailer.share_list_email(:user => user, :list => list).deliver
    end
    user
  end

end
