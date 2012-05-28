class Api::ListsController < Api::BaseController
  respond_to :json

  def index
    list_proxies = current_user.list_proxies.by_position.includes(:list)
    respond_with list_proxies
  end

  def create
    list = List.new(params[:list].merge(user: current_user))
    list.save
    list_proxy = list.proxies.first
    respond_with list_proxy
  end

  def update
    list_params = get_list_params
    sanitize_params
    list_proxy = current_user.list_proxies.find(params[:id])
    logger.info params[:list]
    list_proxy.update_attributes(params[:list])
    respond_with list_proxy
  end

  private

  def get_list_params
    { title: params[:list].delete(:title) } if params[:title]
  end

  def sanitize_params
    params[:list].delete(:tasks)
    params[:list].delete(:id)
  end

end
