class Api::TasksController < Api::BaseController
  respond_to :json

  def index
    list_proxy = current_user.list_proxies.find(params[:list_id])
    tasks = list_proxy.tasks
    respond_with tasks
  end

  def create
    list_proxy = current_user.list_proxies.find(params[:list_id])
    list = list_proxy.list
    task = list.tasks.create(params[:task])
    respond_with task
  end
end
