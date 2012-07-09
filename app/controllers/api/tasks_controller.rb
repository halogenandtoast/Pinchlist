class Api::TasksController < Api::BaseController
  respond_to :json

  def index
    list = current_user.lists.find(params[:list_id])
    tasks = list.tasks
    respond_with tasks
  end

  def create
    list = current_user.lists.find(params[:list_id])
    task = list.tasks.build(params[:task])
    task.save
    respond_with task
  end

  def update
    list = current_user.lists.find(params[:list_id])
    task = list.tasks.find(params[:id])
    if params[:new_position]
      params[:task].merge!(new_position: params[:new_position])
    end
    if task.update_attributes(params[:task])
      render json: task.reload
    else
    end
  end

  def destroy
    list = current_user.lists.find(params[:list_id])
    task = list.tasks.find(params[:id])
    respond_with task.destroy
  end
end
