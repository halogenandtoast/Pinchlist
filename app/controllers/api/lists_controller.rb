class Api::ListsController < Api::BaseController
  respond_to :json

  def index
    lists = current_user.lists.by_position.includes(:list_base)
    respond_with lists
  end

  def create
    respond_with List.create(new_list_params)
  end

  def update
    list = current_user.lists.find(params[:id])
    list.update_attributes(edit_list_params)
    render json: list.reload
  end

  def destroy
    list = current_user.lists.find(params[:id])
    list.destroy
    respond_with list
  end

  private

  def new_list_params
    list_params.merge(user: current_user)
  end

  def edit_list_params
    if params[:new_position]
      list_params.merge(new_position: params[:new_position])
    else
      list_params
    end
  end

  def list_params
    params.
      require(:list).
      permit(:title, :color)
  end
end
