class Discount
  def initialize(user)
    @user = user
  end

  def apply
    customer = Stripe::Customer.retrieve(@user.stripe_customer_token)
    customer.coupon = "1"
    customer.save
  end
end
