class TasksController < ApplicationController
  before_filter :authenticate_user!

  def create
    list = current_user.lists.find(params[:list_id])
    list.tasks.create(params[:task])
    redirect_to dashboard_path, :notice => "Task saved."
  end

  def update
    task = current_user.tasks.find(params[:id])
    task.update_attributes(params[:task])
    respond_to do |format|
      format.js { render :json => task }
    end
  end
end
