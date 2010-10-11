class ListsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @list = current_user.lists.build(params[:list])
    if @list.save
      redirect_to dashboard_path, :notice => 'List created.'
    else
      render 'dashboards/show'
    end
  end
end
