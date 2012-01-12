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

end
