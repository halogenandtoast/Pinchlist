class AccountsController < ApplicationController
  def edit
    @subscription = Plan.basic.subscriptions.new
  end
end
