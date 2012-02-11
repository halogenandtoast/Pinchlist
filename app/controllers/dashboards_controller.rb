class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @list = List.new
    @list_proxies = current_user.list_proxies.by_position.includes(:list)
    @upcoming_tasks = current_user.tasks.upcoming.current.includes(:list)

    unless current_user.subscribed?
      @locked_proxies = @list_proxies[3..-1].map { |proxy| LockedListProxy.new(proxy) }
      @list_proxies = @list_proxies[0..2]
    end
  end
end
