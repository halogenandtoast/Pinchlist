class Api::ListsController < Api::BaseController
  respond_to :json

  def index
    lists = current_user.lists.by_position.includes(:list_base)
    respond_with lists
  end

  def create
    list = List.new(params[:list].merge(user: current_user))
    list.save
    respond_with list
  end

  def update
    list = current_user.lists.find(params[:id])
    list.update_attributes(params[:list].merge(new_position: params[:new_position]))
    respond_with list
  end

end
