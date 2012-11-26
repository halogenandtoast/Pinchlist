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

    list_id = params.fetch(:new_list_id, list.id)
    new_list = current_user.lists.find(list_id)

    if update_task_with_list_base(task, new_list.list_base)
      render json: task.reload
    else
    end
  end

  def destroy
    list = current_user.lists.find(params[:list_id])
    task = list.tasks.find(params[:id])
    respond_with task.destroy
  end

  private

  def update_task_with_list_base(task, list_base)
    logger.info "FOO: #{task.list_base_id} => #{list_base.id}"
    if task.list_base_id != list_base.id
      task.update_attributes_with_list_swap(params[:task].merge(list_base_id: list_base.id))
    else
      task.update_attributes(params[:task])
    end
  end
end
