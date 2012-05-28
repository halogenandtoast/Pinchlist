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
    if params[:new_position]
      params[:list].merge!(new_position: params[:new_position])
    end
    list.update_attributes(params[:list])
    respond_with list
  end

  def destroy
    list = current_user.lists.find(params[:id])
    list.destroy
    respond_with list
  end

end
