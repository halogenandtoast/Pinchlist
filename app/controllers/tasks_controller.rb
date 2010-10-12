class TasksController < ApplicationController

  def create
    list = current_user.lists.find(params[:list_id])
    list.tasks.create(params[:task])
    redirect_to dashboard_path, :notice => "Task saved."
  end
end
