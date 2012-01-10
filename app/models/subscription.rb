class Subscription
  def initialize(user)
    @user = user
  end

  def user
    @user
  end

  def plan_id
    @user.plan_id
  end

  def plan
    @user.plan
  end

  def status
    @user.status
  end

  def create_customer(user)
    Stripe::Customer.create(:description => user.email, :plan => Plan.first.id, :card => user.stripe_card_token)
  end

  def cancel!
    customer.cancel_subscription(:at_period_end => true)
  end

  def resubscribe!
    customer.update_subscription(:plan => Plan.first.id)
  end

  private

  def customer
    @customer ||= Stripe::Customer.retrieve(stripe_customer_token)
  end

  def stripe_customer_token
    @user.stripe_customer_token
  end

  def cancel!
    customer.cancel_subscription(:at_period_end => true)
    update_attributes(:status => 'cancelled')
  end

  def resubscribe!
    customer.update_subscription(:plan => plan_id)
    update_attributes(:status => 'active')
  end

  def self.current
    where("starts_at <= :now AND ends_at >= :now", :now => Time.now)
  end

  def cancelled?
    status == 'cancelled'
  end

  def active?
    status == 'active'
  end

  private

  def customer
    @customer ||= Stripe::Customer.retrieve(stripe_customer_token)
  end

end
