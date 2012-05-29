class Api::TasksController < Api::BaseController
  respond_to :json

  def index
    list = current_user.lists.find(params[:list_id])
    tasks = list.tasks
    respond_with tasks
  end

  def create
    list = current_user.lists.find(params[:list_id])
    base = list.list_base
    task = base.tasks.create(params[:task])
    respond_with task
  end

  def update
    list = current_user.lists.find(params[:list_id])
    task = list.list_base.tasks.find(params[:id])
    if params[:new_position]
      params[:task].merge!(new_position: params[:new_position])
    end
    if task.update_attributes(params[:task])
      render json: task
    else
    end
  end
end
