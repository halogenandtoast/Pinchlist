class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  def new
    @subscription = Plan.basic.subscriptions.new
  end
  def create
    if current_user.subscribe!(params[:subscription])
      redirect_to dashboard_path, :notice => "Thank you for subscribing!"
    else
      redirect_to edit_account_path, :notice => "There was an error."
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
