class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :user
  validates :user_id, :presence => true
  validates :plan_id, :presence => true

  attr_accessor :stripe_card_token

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(:description => user.email, :plan => plan_id, :card => stripe_card_token)
      self.stripe_customer_token = customer.id
      self.starts_at = Time.at(customer.subscription.current_period_start)
      self.ends_at = Time.at(customer.subscription.current_period_end)
      self.status = 'active'
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
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
