class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @list = List.new
    @lists = current_user.lists.by_position.includes(:list_base)
    @upcoming_tasks = current_user.tasks.upcoming.current.includes(:list_base)

    if !current_user.subscribed? && @lists.length > ListBase::SUBSCRIBED_LIMIT
      @locked_lists = @lists[3..-1].map { |list| LockedList.new(list) }
      @lists = @lists[0..2]
    else
      @locked_lists = []
    end
  end
end
