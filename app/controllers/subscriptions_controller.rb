class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @subscription = Plan.basic.subscriptions.new
  end

  def create
    if current_user.subscribe!(params[:subscription][:stripe_card_token])
      redirect_to dashboard_path, notice: "Thank you for subscribing!"
    else
      render "accounts/edit"
    end
  end

  def update
    if current_user.update_subscription!(params[:subscription][:stripe_card_token])
      redirect_to dashboard_path, notice: "Credit card updated!"
    else
      render "accounts/edit"
    end
  end

  def destroy
    current_user.cancel_subscription!
    redirect_to dashboard_path, notice: "Your subscription has been cancelled. You will not be rebilled."
  end
end
