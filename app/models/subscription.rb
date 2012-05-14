class Subscription
  STATUSES = %w(inactive active cancelled permanent expired)

  def initialize(user)
    @user = user
  end

  STATUSES.each do |subscription_status|
    define_method("#{subscription_status}?") { status == "#{subscription_status}" }
  end

  def create(stripe_card_token)
    stripe_transaction do
      params = {
        plan: Plan.first.id,
        description: @user.email,
        email: @user.email,
        card: stripe_card_token
      }
      @customer = Stripe::Customer.create(params)
      Rails.logger.info("STATUS: #{@customer.subscription.status}")
      @user.update_attributes(
        stripe_customer_token: @customer.id,
        starts_at: Time.at(customer.subscription.current_period_start),
        ends_at: Time.at(customer.subscription.current_period_end),
        status: @customer.subscription.status
      )
    end
  end

  def cancel!
    stripe_transaction do
      customer.cancel_subscription(at_period_end: true)
      @user.update_attributes(status: 'cancelled')
    end
  end

  def resubscribe!
    stripe_transaction do
      customer.update_subscription(plan: Plan.first.id)
      @user.update_attributes(status: 'active')
    end
  end

  def update!(card_token)
    stripe_transaction do
      customer.card = card_token
      customer.save
    end
  end

  def current?
    active? || permanent?
  end

  def next_bill_date
    @user.ends_at
  end

  def expiration_date
    @user.ends_at
  end

  private 

  def status
    @user.status
  end

  def customer
    @customer ||= Stripe::Customer.retrieve(stripe_customer_token)
  end

  def stripe_transaction(&block)
    begin
      yield
    rescue Stripe::CardError => e
      @user.errors.add(:base, e.message)
      false
    rescue Stripe::InvalidRequestError, Stripe::AuthenticationError, Stripe::APIError => e
      Rails.logger.error "Stripe error while updating user: #{e.message}"
      @user.errors.add(:base, "There was a problem updating your information with our credit card processor. Please try again later.")
      false
    end
  end

  def stripe_customer_token
    @user.stripe_customer_token
  end

end
