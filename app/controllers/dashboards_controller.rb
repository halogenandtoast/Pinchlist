class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @list = List.new
    # TODO: Clean up
    @list_proxies = current_user.list_proxies.by_position.includes(:list)
    @upcoming_tasks = current_user.tasks.upcoming.current.includes(:list)
  end
end
