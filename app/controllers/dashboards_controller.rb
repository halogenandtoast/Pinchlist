class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @list = List.new
    @lists = current_user.lists.includes(:tasks).order("lists.created_at asc, tasks.created_at asc")
  end
end
