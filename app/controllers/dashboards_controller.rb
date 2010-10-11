class DashboardsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @list = List.new
    @lists = current_user.lists
  end
end
