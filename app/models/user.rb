class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :stripe_card_token
  attr_accessible :email, :password, :password_confirmation, :remember_me, :timezone
  attr_accessible :stripe_customer_token, :starts_at, :ends_at, :status
  attr_accessible :stripe_card_token

  has_many :list_proxies
  has_many :lists, :through => :list_proxies, :readonly => false
  has_many :owned_lists, :class_name => "List"
  has_many :discounts

  delegate :inactive?, :active?, :cancelled?, :permanent?, :expired?, to: :subscription
  delegate :resubscribe!, to: :subscription

  def subscribe!(stripe_card_token)
    subscription.create(stripe_card_token)
    give_discount_to_inviter
  end

  def has_credit?
    available_credit > 0.0
  end

  def use_credit(amount)
    self.available_credit -= amount
    save
  end

  def lifetime_credit
    discounts.sum(:amount)
  end

  def cancel_subscription!
    subscription.cancel!
  end

  def update_subscription!(stripe_card_token)
    subscription.update!(stripe_card_token)
  end

  def proxy_for(list_or_id)
    list_id = list_or_id.is_a?(List) ? list_or_id.id : list_or_id
    list_proxies.find_by_list_id(list_id)
  end

  def tasks
    Task.where(list_id: lists.map(&:id))
  end

  def invitation_to_share(list)
    generate_invitation_token
    self.invitation_sent_at = Time.now
    save(validate: false)
    InvitationWithShareMailer.invitation_for(self, list)
  end

  def subscription
    @subscription ||= Subscription.new(self)
  end

  def subscribed?
    subscription.current?
  end

  private

  def give_discount_to_inviter
    if invitation = Invitation.find_by_invited_user_id(id)
      user = invitation.user
      Discount.create(invited_user_id: id, user_id: user.id, amount: 500)
    end
  end
end
