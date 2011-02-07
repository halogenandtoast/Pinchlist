class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @list = List.new
    @lists = current_user.lists.includes(:tasks).current_tasks.by_task_status
    @upcoming_tasks = current_user.tasks.upcoming.current.includes(:list)
  end
end
