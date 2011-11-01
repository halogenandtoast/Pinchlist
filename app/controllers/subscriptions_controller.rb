class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
  def new
    @subscription = Plan.basic.subscriptions.new
  end
  def create
    @subscription = current_user.subscriptions.new(params[:subscription])
    if @subscription.save_with_payment
      redirect_to @subscription, :notice => "Thank you for subscribing!"
    else
      render :new
    end
  end

end
