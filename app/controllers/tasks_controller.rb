class TasksController < ApplicationController
  before_filter :authenticate_user!

  def create
    @list = current_user.lists.find(params[:list_id])
    @task = @list.tasks.create(params[:task])
    respond_to do |format|
      format.html { redirect_to dashboard_path, :notice => "Task saved." }
      format.js { render }
    end
  end

  def update
    task = current_user.tasks.find(params[:id])
    task.update_attributes(params[:task])
    respond_to do |format|
      format.js { render :json => task.to_json(:user => current_user) }
    end
  end
end
