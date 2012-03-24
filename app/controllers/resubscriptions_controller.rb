class ResubscriptionsController < ApplicationController
  def create
    current_user.resubscribe!
    redirect_to dashboard_path, :notice => "Your subscription has been renewed. You will be billed again on #{current_user.next_bill_date}."
  end
end
