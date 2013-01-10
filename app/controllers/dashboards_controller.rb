class DashboardsController < ApplicationController
  def show
    @lists = current_user.lists

    if !current_user.subscribed? && @lists.length > List::SUBSCRIBED_LIMIT
      @locked_lists = @lists[3..-1].map { |list| LockedList.new(list) }
      @lists = @lists[0..2]
    else
      @locked_lists = []
    end
  end
end
