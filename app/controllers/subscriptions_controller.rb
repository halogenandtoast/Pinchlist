class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  def new
    @subscription = Plan.basic.subscriptions.new
  end
  def create
    @subscription = current_user.subscriptions.new(params[:subscription])
    if @subscription.save_with_payment
      redirect_to dashboard_path, :notice => "Thank you for subscribing!"
    else
      render :new
    end
  end
  def update
    current_user.resubscribe!
    redirect_to dashboard_path, :notice => "Your subscription has been renewed. You will be billed again on #{current_user.next_bill_date}."
  end
  def destroy
    current_user.cancel_subscription!
    redirect_to dashboard_path, :notice => "Your subscription has been cancelled. You will not be rebilled."
  end

end
