class Api::SharesController < Api::BaseController
  respond_to :json
  def create
    list = current_user.lists.find(params[:list_id])
    if list.owned_by?(current_user)
      share = Share.new(params[:share].merge(list_id: list.id, current_user_id: current_user.id))
      if share.save
        render json: share
      else
        render json: share, status: :unprocessible_entity
      end
    end
  end

  def destroy
    list = List.find(params[:id])
    if list.owned_by?(current_user)
      list.destroy
      respond_with list
    end
  end
end
